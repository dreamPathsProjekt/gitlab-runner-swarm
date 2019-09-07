#!/bin/bash

if [ -z "${PROJECT_REGISTRATION_TOKEN}" ]; then
    PROJECT_REGISTRATION_TOKEN=$(cat /run/secrets/project_registration_token)
fi

if [ -z "${GITLAB_URL}" ]; then
    GITLAB_URL=$(cat /run/secrets/gitlab_url)
fi

if [ ! -z "${DOCKER_VOLUME_2}" ] && [ ! -z "${DOCKER_VOLUME_3}" ] && [ ! -z "${DOCKER_VOLUME_4}" ] && [ ! -z "${DOCKER_VOLUME_5}" ]; then
    gitlab-runner register \
            --non-interactive \
            --executor "${RUNNER_EXECUTOR:-docker}" \
            --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest}" \
            --docker-volumes "${DOCKER_VOLUME_1:-/var/run/docker.sock:/var/run/docker.sock}" \
            --docker-volumes "${DOCKER_VOLUME_2}" \
            --docker-volumes "${DOCKER_VOLUME_3}" \
            --docker-volumes "${DOCKER_VOLUME_4}" \
            --docker-volumes "${DOCKER_VOLUME_5}" \
            --url "${GITLAB_URL:-https://gitlab.com/}" \
            --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
            --description "${RUNNER_DESCRIPTION:-docker-runner}" \
            --tag-list "${TAG_LIST:-docker}" \
            --run-untagged="${RUN_UNTAGGED:-true}" \
            --locked="${LOCKED:-false}" \
            --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
            --access-level="${ACCESS_LEVEL:-not_protected}"
elif [ ! -z "${DOCKER_VOLUME_2}" ] && [ ! -z "${DOCKER_VOLUME_3}" ] && [ ! -z "${DOCKER_VOLUME_4}" ]; then
    gitlab-runner register \
            --non-interactive \
            --executor "${RUNNER_EXECUTOR:-docker}" \
            --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest}" \
            --docker-volumes "${DOCKER_VOLUME_1:-/var/run/docker.sock:/var/run/docker.sock}" \
            --docker-volumes "${DOCKER_VOLUME_2}" \
            --docker-volumes "${DOCKER_VOLUME_3}" \
            --docker-volumes "${DOCKER_VOLUME_4}" \
            --url "${GITLAB_URL:-https://gitlab.com/}" \
            --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
            --description "${RUNNER_DESCRIPTION:-docker-runner}" \
            --tag-list "${TAG_LIST:-docker}" \
            --run-untagged="${RUN_UNTAGGED:-true}" \
            --locked="${LOCKED:-false}" \
            --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
            --access-level="${ACCESS_LEVEL:-not_protected}"
elif [ ! -z "${DOCKER_VOLUME_2}" ] && [ ! -z "${DOCKER_VOLUME_3}" ]; then
    gitlab-runner register \
            --non-interactive \
            --executor "${RUNNER_EXECUTOR:-docker}" \
            --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest}" \
            --docker-volumes "${DOCKER_VOLUME_1:-/var/run/docker.sock:/var/run/docker.sock}" \
            --docker-volumes "${DOCKER_VOLUME_2}" \
            --docker-volumes "${DOCKER_VOLUME_3}" \
            --url "${GITLAB_URL:-https://gitlab.com/}" \
            --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
            --description "${RUNNER_DESCRIPTION:-docker-runner}" \
            --tag-list "${TAG_LIST:-docker}" \
            --run-untagged="${RUN_UNTAGGED:-true}" \
            --locked="${LOCKED:-false}" \
            --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
            --access-level="${ACCESS_LEVEL:-not_protected}"
elif [ ! -z "${DOCKER_VOLUME_2}" ]; then
    gitlab-runner register \
            --non-interactive \
            --executor "${RUNNER_EXECUTOR:-docker}" \
            --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest}" \
            --docker-volumes "${DOCKER_VOLUME_1:-/var/run/docker.sock:/var/run/docker.sock}" \
            --docker-volumes "${DOCKER_VOLUME_2}" \
            --url "${GITLAB_URL:-https://gitlab.com/}" \
            --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
            --description "${RUNNER_DESCRIPTION:-docker-runner}" \
            --tag-list "${TAG_LIST:-docker}" \
            --run-untagged="${RUN_UNTAGGED:-true}" \
            --locked="${LOCKED:-false}" \
            --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
            --access-level="${ACCESS_LEVEL:-not_protected}"
else
    gitlab-runner register \
            --non-interactive \
            --executor "${RUNNER_EXECUTOR:-docker}" \
            --docker-image "${DOCKER_DEFAULT_IMAGE:-docker:latest}" \
            --docker-volumes "${DOCKER_VOLUME_1:-/var/run/docker.sock:/var/run/docker.sock}" \
            --url "${GITLAB_URL:-https://gitlab.com/}" \
            --registration-token "${PROJECT_REGISTRATION_TOKEN}" \
            --description "${RUNNER_DESCRIPTION:-docker-runner}" \
            --tag-list "${TAG_LIST:-docker}" \
            --run-untagged="${RUN_UNTAGGED:-true}" \
            --locked="${LOCKED:-false}" \
            --docker-privileged="${DOCKER_PRIVILEGED:-true}" \
            --access-level="${ACCESS_LEVEL:-not_protected}"
fi

exec /entrypoint "$@"