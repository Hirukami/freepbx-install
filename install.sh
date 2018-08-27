#!/bin/bash
if [ $(getenforce) != "Disabled" ]; then
   sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
   sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
   echo "SElinux disabled, pls reboot VM"
   exit 1
fi

if [ $(whoami) != "root" ]; then
   echo "Run script from user root"
   exit 1
fi

yum install mercurial git tmux -y
git clone https://github.com/Hirukami/freepbx-install.git
cd freepbx-install
tmux new-session -d -s freepbx -n freepbx
tmux send-keys -t freepbx:freepbx "bash freepbx-install.sh" Enter
tmux attach -t freepbx
