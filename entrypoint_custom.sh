#!/bin/bash

if [ -z "${PROJECT_REGISTRATION_TOKEN}" ]; then
    PROJECT_REGISTRATION_TOKEN=$(cat /run/secrets/project_registration_token)
fi

if [ -z "${GITLAB_URL}" ]; then
    GITLAB_URL=$(cat /run/secrets/gitlab_url)
fi

gitlab-runner register \
        --non-interactive \
        --executor "docker" \
        --docker-image docker:latest \
        --docker-volumes "${DOCKER_VOLUMES:-/var/run/docker.sock:/var/run/docker.sock}" \
        --url "${GITLAB_URL:-https://gitlab.com/}" \
        --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
        --description "${RUNNER_DESCRIPTION:-docker-runner}" \
        --tag-list "${TAG_LIST:-docker}" \
        --run-untagged="${RUN_UNTAGGED:-true}" \
        --locked="${LOCKED:-false}" \
        --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
        --access-level="${ACCESS_LEVEL:-not_protected}"

exec /entrypoint "$@"