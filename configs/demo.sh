#!/bin/sh

# Git 仓库地址
git_repo="https://github.com/SANGET/fe-deploy-shell.git"

# 需要推送到的远端的 ssh host
ssh_host_name="ssh"

# 远端部署路径
remote_project_deploy_dir="/var/www/frontend/project"

# 备份目录
remote_project_bak_dir="/var/www/frontend/bak"

export git_repo
export ssh_host_name
export remote_project_deploy_dir
export remote_project_bak_dir
