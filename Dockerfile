FROM centos:7
COPY . /freepbx
SHELL ["/bin/bash", "-c"]
RUN yum install openssl -y
RUN /freepbx/freepbx-install.sh
CMD tail -f /var/log/asterisk/freepbx.log
