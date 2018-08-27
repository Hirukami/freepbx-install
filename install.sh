#!/bin/sh
yum install mercurial git tmux -y
git clone https://github.com/Hirukami/freepbx-install.git
cd freepbx-install
tmux new-session -d -s freepbx -n freepbx
tmux send-keys -t freepbx:freepbx "bash freepbx-install.sh" Enter
tmux attach -t freepbx
