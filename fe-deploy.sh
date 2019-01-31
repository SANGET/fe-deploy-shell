#!/bin/sh

# 远端配置，需要与 SA 沟通

remote_project_store_dir="/tmp" # 远端存放压缩包的目录
remote_project_deploy_dir="" # 远端部署目录
remote_project_bak_dir="" # 远端部署目录

# 本地变量，根据传入的参数做选择配置

git_repo="" # git 仓库地址
ssh_host_name="" # ssh host
project_name=$1 # 项目名称

config_sh_path="./configs/${project_name}.sh"

start_datestamp=$(date +%s)

echo $config_sh_path

if [ ! -f $config_sh_path ]; then
  echo "没找到 ${project_name} 配置, 请在添加 ${config_sh_path}"
  exit 0
fi

. $config_sh_path

# 本地路径

local_clone_dir="./clone"

# 进入本地的 git 克隆目录

mkdir -p $local_clone_dir
cd $local_clone_dir

if [[ ! -d $project_name ]]; then
  # 如果不存在文件则 clone
  echo "cloning 项目 ${git_repo}"
  git clone $git_repo $project_name
  echo "cloned"
  cd $project_name
else
  echo "pulling 项目"
  cd $project_name
  git pull origin master
fi

echo "正在安装程序"

yarn

echo "安装完成"

echo "正在编译程序"

yarn build

echo "编译完成，正在压缩程序"

rm -Rf ./zip-build;
mkdir -p ./zip-build;
cp -R ./build ./zip-build;
cd ./zip-build;

tar -zcvf ./build.tar.gz ./build

now_datetime=$(date +%Y%m%d-%H%M%S)
ssh_project_store_dir="${remote_project_store_dir}/${project_name}"
ssh_project_deploy_dir="${remote_project_deploy_dir}"
bak_dir_for_this_time="${remote_project_bak_dir}/${now_datetime}"
scp_target_dir="./build.tar.gz"
deploy_file="${ssh_project_store_dir}/build.tar.gz"

echo "正在推送压缩包"

ssh ${ssh_host_name} "mkdir -p ${ssh_project_deploy_dir}; mkdir -p ${ssh_project_store_dir}"

scp -rB ${scp_target_dir} ${ssh_host_name}:${ssh_project_store_dir}

echo "正在解压 ${deploy_file}"

ssh -t ${ssh_host_name} << EOF
  tar zxvf $deploy_file -C ${ssh_project_store_dir}
  mkdir -p $bak_dir_for_this_time
  mv ${ssh_project_deploy_dir}/* ${bak_dir_for_this_time}/
  mv -f ${ssh_project_store_dir}/build/* ${ssh_project_deploy_dir}/
EOF

echo "解压完成，部署完成。"

end_datestamp=$(date +%s)

time_cost=$[ end_datestamp - start_datestamp ]

echo "共花 ${time_cost} 秒"

exit 0
