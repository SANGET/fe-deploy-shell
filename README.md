# 前端部署脚本

## 依赖

- yarn
- nrm
- node
- npm

## 目录结构

- fe-deploy.sh 主脚本程序
- config/ 存放对应的部署脚本
  - xx/xx.sh 对应的平台的部署脚本
- clone/ 存放通过 git clone 下来的项目

## 使用脚本

```shell
# 根据 projectName/platform 编写对应的配置
sh ./fe-deploy.sh projectName/platform
# 会自动寻找 ./configs/projectName/platform.sh 文件
# 在 clone/projectName/platform 目录下克隆对应的 git 项目
```

## 添加发布脚本配置

在 **./configs/** 目录下，增删改以下 sh 配置文件

```shell
#!/bin/sh

# Git 仓库地址
git_repo="https://gitlab.99safe.org/casino-web-group/casino-admin.git"

# 需要推送到的远端的 ssh host
ssh_host_name="fe-deployment"

# 远端部署路径
remote_project_deploy_dir="/var/www/frontend" # 远端部署目录

export git_repo
export ssh_host_name
export remote_project_deploy_dir
```

## 命名建议以及配置过程

### 命名建议

> projectName 项目名称的拼音

- 前端 -> qianduan

在 configs 目录下添加 qianduan.sh 文件

```shell
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
```
