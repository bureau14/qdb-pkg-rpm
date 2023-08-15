FROM docker.io/amazonlinux:2

RUN yum install -y gettext \
                   openssl \
                   rpm \
                   rpm-build \
                   rpm-sign \
    && yum clean all
RUN mkdir -p ~/.gnupg/ \
    && echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf \
    && chmod -R 600 ~/.gnupg/
