#!/bin/bash
yum install mercurial git tmux -y
hg clone ssh://hg@bitbucket.org/golubev_nk/freepbx-install
cd freepbx-install
tmux
bash freepbx-install.sh
