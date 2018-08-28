FROM centos:7
COPY . /freepbx
RUN bash /freepbx/install.sh
CMD bash tail -f /var/log/asterisk/freepbx.log
