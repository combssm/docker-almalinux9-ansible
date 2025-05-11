FROM almalinux:9
LABEL maintainer="combssm@gmail.com"
ENV container=docker

ENV pip_packages "ansible"
RUN dnf -y update && dnf clean all

RUN dnf -y install systemd && dnf clean all && \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfile-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN dnf makecache \
 && dnf -y install rpm dnf-plugins-core \
  && dnf -y update \
  && dnf -y install \
      epel-release \
      hostname \
      initscripts \
      iproute \
      libyaml \
      net-tools \
      python3 \
      python3-pip \
      sudo \
      vim \
      wget \
      which \
  && dnf clean all

RUN pip3 install $pip_packages

RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
