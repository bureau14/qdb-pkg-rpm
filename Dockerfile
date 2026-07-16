FROM docker.io/amazonlinux:2

# We need to ensure that the container user has the same UID and GID as the host buildkite agent to use the `propagate-uid-gid` feature of the docker plugin.
# The default UID, GID matches the default UID, GID of the buildkite agent on the host, if needed can be overridden
ARG USER_ID=929
ARG GROUP_ID=929
ARG USERNAME=builder
ARG HOME=/home/${USERNAME}
ARG COMMENT=builder

RUN yum install -y gettext \
                   openssl \
                   rpm \
                   rpm-build \
                   rpm-sign \
    && yum clean all

RUN groupadd --gid $GROUP_ID $USERNAME
RUN useradd --comment "$COMMENT" --home-dir $HOME --create-home --system --uid $USER_ID --gid $GROUP_ID $USERNAME
USER $USERNAME

RUN mkdir -p ~/.gnupg/ \
&& echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf \
&& chmod 700 ~/.gnupg/ \
&& chmod 600 ~/.gnupg/gpg-agent.conf
