FROM centos:latest

RUN yum update -y \
    && yum install -y expect \
                      gettext \
                      openssl \
                      rpm \
                      rpm-build \
                      rpm-sign \
