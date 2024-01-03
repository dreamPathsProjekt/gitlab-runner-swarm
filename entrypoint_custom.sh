#!/usr/bin/env bash

set -o errexit  # abort on nonsero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

if [ -z "${PROJECT_REGISTRATION_TOKEN}" ]; then
    PROJECT_REGISTRATION_TOKEN=$(cat /run/secrets/project_registration_token)
fi

if [ -z "${GITLAB_URL}" ]; then
    GITLAB_URL=$(cat /run/secrets/gitlab_url)
fi

REGISTER_COMMAND="gitlab-runner register \
    --non-interactive \
    --executor \"${RUNNER_EXECUTOR:-docker}\" \
    --docker-image \"${DOCKER_DEFAULT_IMAGE:-docker:latest}\" \
    --url \"${GITLAB_URL:-https://gitlab.com/}\" \
    --registration-token \"${PROJECT_REGISTRATION_TOKEN}\" \
    --description \"${RUNNER_DESCRIPTION:-docker-runner}\" \
    --tag-list \"${TAG_LIST:-docker}\" \
    --run-untagged=\"${RUN_UNTAGGED:-true}\" \
    --locked=\"${LOCKED:-false}\" \
    --docker-privileged=\"${DOCKER_PRIVILEGED:-true}\" \
    --access-level=\"${ACCESS_LEVEL:-not_protected}\""

if [ -n "${DOCKER_VOLUMES_LIST}" ]; then
    IFS=',' read -ra volumes <<< "${DOCKER_VOLUMES_LIST}"
    for volume in "${volumes[@]}"
    do
        echo "$0: Adding Docker Volume \"${volume}\"..."
        REGISTER_COMMAND="${REGISTER_COMMAND} --docker-volumes \"${volume}\""
    done
fi

# Allow for custom CA file
if [ -n "${CUSTOM_CA_PATH}" ]; then
    if [[ ! -r "${CUSTOM_CA_PATH}" ]]; then
        echo "$0: WARN: Custom CA Path <${CUSTOM_CA_PATH}> is not readable. Registration will likely fail"
    else
        echo "$0: Adding Custom CA \"${CUSTOM_CA_PATH}\"..."
        REGISTER_COMMAND="${REGISTER_COMMAND} --tls-ca-file \"${CUSTOM_CA_PATH}\""
    fi
fi

echo "$0: Registering this runner..."
echo "$REGISTER_COMMAND"
# shellcheck disable=SC2086
eval $REGISTER_COMMAND

exec /entrypoint "$@"
