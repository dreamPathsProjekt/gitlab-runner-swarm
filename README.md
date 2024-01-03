# Gitlab Runner Swarm

Runs a Gitlab Runner in a manner compatible with Docker Swarm.

## Setup

- Clone the repository & deploy the compose file [compose.yml](./compose.yml) as a stack,
  after you have configured you preferred settings (e.g. variables, secrets, replicas etc.)

  ```bash
  docker stack deploy -c gitlab-runners.yml <stack-name>
  ```

- You can scale gitlab runners up, using:

  ```bash
  docker service scale <stack-name>_runner=<number-of-replicas>
  ```

## Environment Variables Reference

All variables can be referenced in
[Official Docker Runner Registration Options](https://docs.gitlab.com/runner/register/#docker)
and/or running command `gitlab-runner register -h`

- `GITLAB_URL`: GitLab instance URL, can also be deployed as a Swarm __secret__ target: `gitlab_url`.
  Default value: `https://gitlab.com/`.
- `PROJECT_REGISTRATION_TOKEN`: token you obtained to register the Runner, can also be deployed
  as a Swarm __secret__ target: `project_registration_token`.
- `RUNNER_EXECUTOR`: Runner executor - Valid values:

  - `ssh`
  - `docker+machine`
  - `docker-ssh+machine`
  - `kubernetes`
  - `docker`
  - `parallels`
  - `virtualbox`
  - `docker-ssh`
  - `shell`

  Default `docker`.
- `DOCKER_DEFAULT_IMAGE`: If you chose Docker as your executor, you’ll be asked for the default
  image to be used for projects that do not define one. Default: `docker:latest`.
- `RUNNER_DESCRIPTION`: Enter a description for the Runner.
- `TAG_LIST`: Gitlab-Ci tags for this runner - comma separated. Default: `docker`.
- `RUN_UNTAGGED`: Register to run untagged builds. Default: `true`.
- `LOCKED`: Lock Runner for current project. Default: `false`.
- `DOCKER_PRIVILEGED`:  Give extended privileges to container. Default: `true`.
- `ACCESS_LEVEL`: Set access_level of the runner to not_protected or ref_protected. Default: `not_protected`.
- `DOCKER_VOLUMES_LIST`: Bind-mount one or more volumes and create it/them if doesn't exist prior to
  mounting - comma separated. Example: `/var/run/docker.sock:/var/run/docker.sock` (binds to default
  docker socket in the host).
- `CUSTOM_CA_PATH`: If your `GITLAB_URL` is signed by a custom Certificate Authority, you can provide a path
  to the CA file here. If supplied, this must be readable within the container.
  - e.g. if your CA file is in a volume you might specify it as `/opt/my-ca.crt`.
  - Alternatively, if you use a docker __secret__, specify `/run/secrets/<secret_name>` here.

> [!TIP]
> Do not forget to also add the volumes specified in `DOCKER_VOLUMES_LIST`, to the `volumes` section in compose file.
