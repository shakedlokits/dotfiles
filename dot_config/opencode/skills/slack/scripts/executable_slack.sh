#!/bin/bash
#
# Slack Web API CLI wrapper.
# Reads JSON params from stdin, posts to https://slack.com/api/<method>
# using xoxc/xoxd tokens extracted by slack-token-extractor.

set -euo pipefail

readonly TOKEN_FILE="${HOME}/Documents/Projects/slack-token-extractor/.slack_tokens.env"
readonly SETUP_INSTRUCTIONS='Slack tokens not found or expired. To extract tokens, run:

1. Clone the extractor repository (https://github.com/maorfr/slack-token-extractor.git) to /tmp
2. Install the python dependencies in a virtualenv
3. Run "python playwright_extract.py" and follow the instructions.

This will open a browser window for you to log into Slack and approve access.'

readonly AUTH_ERRORS='invalid_auth not_authed token_expired token_revoked account_inactive'

err() {
	echo "Error: $*" >&2
}

usage() {
	cat <<'EOF'
Usage: slack.sh <method>

Calls a Slack Web API method as the authenticated user. Reads method
parameters as a JSON object from stdin and form-encodes them.

Examples:
  echo '{"channel":"C08DJH3UJRK","limit":20}' \
    | bash scripts/slack.sh conversations.history

  echo '{"channel":"C123","text":"hello"}' \
    | bash scripts/slack.sh chat.postMessage

  echo '{"query":"from:@me has:link"}' \
    | bash scripts/slack.sh search.messages

See https://docs.slack.dev/reference/methods for available methods.
EOF
}

#######################################
# Load xoxc + xoxd tokens from the extractor env file.
# Outputs:
#   "<xoxc>\t<xoxd>" on stdout.
# Returns:
#   1 if file is missing or tokens cannot be parsed.
#######################################
load_tokens() {
	if [[ ! -f "${TOKEN_FILE}" ]]; then
		return 1
	fi
	local xoxc xoxd
	xoxc="$(grep -E '^SLACK_MCP_XOXC_TOKEN=' "${TOKEN_FILE}" | head -n1 | cut -d= -f2- | tr -d '"' || true)"
	xoxd="$(grep -E '^SLACK_MCP_XOXD_TOKEN=' "${TOKEN_FILE}" | head -n1 | cut -d= -f2- | tr -d '"' || true)"
	if [[ -z "${xoxc}" || -z "${xoxd}" ]]; then
		return 1
	fi
	printf '%s\t%s\n' "${xoxc}" "${xoxd}"
}

#######################################
# Convert a JSON object on stdin into a URL-encoded form body.
# Object/array values are serialized as JSON strings (Slack convention).
#######################################
to_form_body() {
	jq -rj '
    to_entries
    | map(
        (.value
          | if type == "object" or type == "array" then tojson else tostring end
          | @uri) as $v
        | (.key | @uri) + "=" + $v
      )
    | join("&")
  '
}

#######################################
# Check whether a Slack response body indicates a token/auth failure.
# Arguments:
#   Response body string.
# Returns:
#   0 if it is an auth error, 1 otherwise.
#######################################
is_auth_error() {
	local body="$1"
	local code
	code="$(printf '%s' "${body}" | jq -r '.error // empty' 2>/dev/null || true)"
	[[ -z "${code}" ]] && return 1
	for known in ${AUTH_ERRORS}; do
		if [[ "${code}" == "${known}" ]]; then
			return 0
		fi
	done
	return 1
}

main() {
	if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
		usage
		[[ $# -lt 1 ]] && exit 2 || exit 0
	fi

	local method="$1"

	local tokens
	if ! tokens="$(load_tokens)"; then
		echo "${SETUP_INSTRUCTIONS}"
		exit 1
	fi
	local xoxc xoxd
	xoxc="${tokens%$'\t'*}"
	xoxd="${tokens#*$'\t'}"

	local params_json
	params_json="$(cat)"
	if [[ -z "${params_json// /}" ]]; then
		params_json='{}'
	fi
	if ! printf '%s' "${params_json}" | jq -e 'type == "object"' >/dev/null 2>&1; then
		err "params must be a JSON object, got: ${params_json}"
		exit 2
	fi

	local body
	body="$(printf '%s' "${params_json}" | to_form_body)"

	local tmp http_code response
	tmp="$(mktemp)"
	TMPFILE="${tmp}"
	trap 'rm -f "${TMPFILE-}"' EXIT

	http_code="$(curl -sS \
		-o "${tmp}" \
		-w '%{http_code}' \
		-X POST \
		-H "Authorization: Bearer ${xoxc}" \
		-H "Cookie: d=${xoxd}" \
		-H "Content-Type: application/x-www-form-urlencoded" \
		--data "${body}" \
		"https://slack.com/api/${method}")"

	response="$(cat "${tmp}")"

	if is_auth_error "${response}"; then
		echo "Slack API returned a token error. Your tokens may have expired."
		echo
		echo "${SETUP_INSTRUCTIONS}"
		exit 1
	fi

	if [[ "${http_code}" -lt 200 || "${http_code}" -ge 300 ]]; then
		err "Slack API HTTP ${http_code}: ${response}"
		exit 1
	fi

	printf '%s\n' "${response}"
}

main "$@"
