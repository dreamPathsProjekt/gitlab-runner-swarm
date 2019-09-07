#!/bin/bash

if [ -z "${PROJECT_REGISTRATION_TOKEN}" ]; then
    PROJECT_REGISTRATION_TOKEN=$(cat /run/secrets/project_registration_token)
fi

if [ -z "${GITLAB_URL}" ]; then
    GITLAB_URL=$(cat /run/secrets/gitlab_url)
fi

DOCKER_VOLUMES_COMMAND=''

if [ ! -z "${DOCKER_VOLUMES_LIST}" ]; then
    IFS=',' read -ra volumes <<< "${DOCKER_VOLUMES_LIST}"
    for volume in "${volumes[@]}"
    do
        DOCKER_VOLUMES_COMMAND="${DOCKER_VOLUMES_COMMAND} --docker-volumes ${volume}"
    done
fi

gitlab-runner register \
        --non-interactive \
        --executor "${RUNNER_EXECUTOR:-docker}" \
        --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest} ${DOCKER_VOLUMES_COMMAND}" \
        --url "${GITLAB_URL:-https://gitlab.com/}" \
        --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
        --description "${RUNNER_DESCRIPTION:-docker-runner}" \
        --tag-list "${TAG_LIST:-docker}" \
        --run-untagged="${RUN_UNTAGGED:-true}" \
        --locked="${LOCKED:-false}" \
        --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
        --access-level="${ACCESS_LEVEL:-not_protected}"

exec /entrypoint "$@"