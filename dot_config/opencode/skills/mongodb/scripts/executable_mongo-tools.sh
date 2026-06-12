#!/bin/bash
#
# MongoDB CLI utility for querying production databases.
# Supports querying, schema inspection, and environment listing.
# Environments are configured in ~/.config/mongo-utils/.env

set -euo pipefail

readonly ENV_FILE="${HOME}/.config/mongo-tools/.env"
readonly SCHEMA_DIR="${HOME}/.config/mongo-tools/schemas"
readonly TIMEOUT_SECONDS=300
readonly SCHEMA_SAMPLES=1000
readonly SCHEMA_MAX_AGE_DAYS=30

#######################################
# Print error message to stderr.
# Arguments:
#   Error message string.
#######################################
err() {
  echo "Error: $*" >&2
}

#######################################
# Check that a required dependency is installed.
# Arguments:
#   Command name.
#   Install instruction.
# Returns:
#   1 if dependency is missing.
#######################################
require() {
  local cmd="$1"
  local install_hint="$2"

  if ! command -v "${cmd}" &>/dev/null; then
    err "Required dependency '${cmd}' not found."
    err "Install with: ${install_hint}"
    exit 1
  fi
}

#######################################
# Load environment variables from .env file.
# Globals:
#   ENV_FILE
# Returns:
#   1 if .env file not found.
#######################################
load_env() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    err "MongoDB environments not configured."
    err ""
    err "Create ${ENV_FILE} with connection strings:"
    err "  mkdir -p $(dirname "${ENV_FILE}")"
    err "  cat > ${ENV_FILE} <<EOF"
    err "  production=mongodb+srv://user:password@host"
    err "  production_eu=mongodb+srv://user:password@host"
    err "  EOF"
    err ""
    err "Each line is an environment. The variable name is the environment name."
    err "Add as many environments as needed (e.g., staging, dev, local)."
    err "Ask the user for MongoDB connection strings if not available."
    exit 1
  fi
  # shellcheck source=/dev/null
  source "${ENV_FILE}"
}

#######################################
# Resolve MongoDB URI for an environment.
# Arguments:
#   Environment name (must match a variable in .env).
# Outputs:
#   Writes MongoDB URI to stdout.
# Returns:
#   1 if environment is unknown.
#######################################
resolve_uri() {
  local env="$1"
  local uri="${!env:-}"

  if [[ -z "${uri}" ]]; then
    err "Unknown environment '${env}'"
    cmd_envs >&2
    exit 1
  fi
  echo "${uri}"
}

#######################################
# Run a JS query from stdin against a MongoDB database.
# Arguments:
#   Environment name.
#   Database name.
# Outputs:
#   Query results to stdout.
#######################################
cmd_query() {
  require "mongosh" "brew install mongosh"

  local env="${1:?Usage: $0 query <environment> <database>}"
  local db="${2:?Usage: $0 query <environment> <database>}"

  load_env
  local uri
  uri="$(resolve_uri "${env}")"

  timeout "${TIMEOUT_SECONDS}" mongosh "${uri}/${db}" --quiet --norc \
    --file /dev/stdin
}

#######################################
# Inspect collection schema (field names and types).
# Uses mongodb-schema to sample documents and infer types.
# Caches results to ~/.config/mongo-utils/schemas/ for 30 days.
# Arguments:
#   Environment name.
#   Database name.
#   Collection name.
# Outputs:
#   JSON array of {type, path} objects to stdout.
#######################################
cmd_inspect() {
  require "mongodb-schema" "npm install -g mongodb-schema"
  require "jq" "brew install jq"

  local env="${1:?Usage: $0 inspect <environment> <database> <collection>}"
  local db="${2:?Usage: $0 inspect <environment> <database> <collection>}"
  local coll="${3:?Usage: $0 inspect <environment> <database> <collection>}"

  load_env
  local uri
  uri="$(resolve_uri "${env}")"

  mkdir -p "${SCHEMA_DIR}"
  local today
  today="$(date +%Y-%m-%d)"
  local cache_pattern="${SCHEMA_DIR}/*_${env}_${db}_${coll}.json"
  local cache_file="${SCHEMA_DIR}/${today}_${env}_${db}_${coll}.json"

  # Check for existing cache file
  local existing
  existing="$(ls -1 ${cache_pattern} 2>/dev/null | head -1 || true)"

  if [[ -n "${existing}" ]]; then
    # Check age
    local file_date
    file_date="$(basename "${existing}" | cut -d'_' -f1)"
    local file_epoch
    file_epoch="$(date -j -f '%Y-%m-%d' "${file_date}" '+%s' 2>/dev/null || echo 0)"
    local now_epoch
    now_epoch="$(date '+%s')"
    local age_days=$(( (now_epoch - file_epoch) / 86400 ))

    if (( age_days < SCHEMA_MAX_AGE_DAYS )); then
      cat "${existing}"
      return
    fi

    # Stale — remove old file before refreshing
    rm -f "${existing}"
  fi

  # Run mongodb-schema and filter with jq
  local jq_filter
  read -r -d '' jq_filter <<'JQ' || true
first(inputs)
| [.. | .types? | select(.) | .[]]
| map({type: .name, probability: .probability, path: (.path | join("."))})
| group_by(.path)
| map(map(select(.type != "Undefined")) | max_by(.probability) | del(.probability))
JQ

  timeout "${TIMEOUT_SECONDS}" \
    mongodb-schema "${uri}" "${db}.${coll}" \
      --number="${SCHEMA_SAMPLES}" --format=json --no-values --no-stats \
      2>/dev/null \
    | jq -n "${jq_filter}" \
    | tee "${cache_file}"
}

#######################################
# List all databases and their collections.
# Arguments:
#   Environment name.
# Outputs:
#   Database names with indented collection names to stdout.
#######################################
cmd_dbs() {
  require "mongosh" "brew install mongosh"

  local env="${1:?Usage: $0 dbs <environment>}"

  load_env
  local uri
  uri="$(resolve_uri "${env}")"

  echo '
db.getMongo().getDBNames().forEach(dbName => {
  print(dbName);
  const colls = db.getSiblingDB(dbName).getCollectionNames().sort();
  colls.forEach(c => print("  " + c));
});
' | timeout "${TIMEOUT_SECONDS}" mongosh "${uri}" --quiet --norc \
      --file /dev/stdin
}

#######################################
# List available environments from .env file.
# Globals:
#   ENV_FILE
# Outputs:
#   Environment names to stdout.
#######################################
cmd_envs() {
  load_env
  echo "Available environments:"
  local var
  while IFS='=' read -r var _; do
    [[ "${var}" =~ ^#.*$ || -z "${var}" ]] && continue
    echo "  ${var}"
  done < "${ENV_FILE}"
}

#######################################
# Print usage information.
# Outputs:
#   Usage text to stdout.
#######################################
cmd_usage() {
  cat <<EOF
Usage: $0 <command> [args]

Commands:
  query   <env> <database>                Run JS from stdin
  inspect <env> <database> <collection>   Show collection schema
  dbs     <env>                           List databases and collections
  envs                                    List environments

Examples:
  echo 'db.companies.findOne()' | $0 query production companies
  $0 inspect production apis unifiedEndpointView
  $0 dbs production
  $0 envs
EOF
}

#######################################
# Main entry point.
# Arguments:
#   Command and its arguments.
#######################################
main() {
  case "${1:-}" in
    query)   shift; cmd_query "$@" ;;
    inspect) shift; cmd_inspect "$@" ;;
    dbs)     shift; cmd_dbs "$@" ;;
    envs)    cmd_envs ;;
    *)       cmd_usage ;;
  esac
}

main "$@"
