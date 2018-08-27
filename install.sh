#!/bin/bash
yum install mercurial git tmux -y
git clone https://github.com/Hirukami/freepbx-install.git
cd freepbx-install
tmux
bash freepbx-install.sh
