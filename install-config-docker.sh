#!/bin/bash

gitrepo=https://raw.githubusercontent.com/mrajani
curl -sSL \
 ${gitrepo}/learndocker/master/install_docker.sh  | bash
curl -sSL \
 ${gitrepo}/utilityscripts/master/install_zsh.sh | bash

