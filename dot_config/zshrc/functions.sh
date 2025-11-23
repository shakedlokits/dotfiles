#                                                          
#                                                          
#    ▄▄▄▄▄ ▄▄ ▄▄ ▄▄  ▄▄  ▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄  ▄▄▄▄ 
#    ██▄▄  ██ ██ ███▄██ ██▀▀▀   ██   ██ ██▀██ ███▄██ ███▄▄ 
#    ██    ▀███▀ ██ ▀██ ▀████   ██   ██ ▀███▀ ██ ▀██ ▄▄██▀ 
#                                                          
#    This file contains all of the helper functions.
#    Add here all of the utils you're build - can also use Mise.

# Docker utilities
docker-clear-images(){ docker images -aq | xargs -I {} docker rmi --force {}; }

docker-clear-containers() { docker ps -aq | xargs -I {} docker stop {} | xargs -I {} docker rm {}; }

# Git utilities
ls-pr(){git --no-pager diff --name-only $(git branch | grep \* | cut -d ' ' -f2) $(git merge-base $(git branch | grep \* | cut -d ' ' -f2) master);}

gh-pr-comments() {eval $(gh pr view --json headRepository,headRepositoryOwner,number | jq -r '. | "PR_OWNER=\(.headRepositoryOwner.login) PR_REPO=\(.headRepository.name) PR_NUMBER=\(.number)"') && gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$PR_OWNER/$PR_REPO/pulls/$PR_NUMBER/comments" | jq '.[] | select( .updated_at == .created_at ) | {id: .id, body: .body, path: "\(.path):\(.line)", diff_hunk, user: .user.login}'};

