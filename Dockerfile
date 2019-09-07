FROM gitlab/gitlab-runner:latest
LABEL maintainer="Ioannis Dritsas <dream.paths.projekt@gmail.com>"

COPY entrypoint_custom.sh /
RUN chmod a+x /entrypoint_custom.sh
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint_custom.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
