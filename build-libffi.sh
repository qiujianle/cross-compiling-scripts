#!/bin/sh

# set -v 

PLATFORM=arm-linux-gnueabihf
SCRIPT_PATH=$(pwd)

#修改源码包解压后的名称
MAJOR_NAME=libffi

#修改需要下载的源码前缀和后缀
OPENSRC_VER_PREFIX=3
OPENSRC_VER_SUFFIX=.3

PACKAGE_NAME=${MAJOR_NAME}-${OPENSRC_VER_PREFIX}${OPENSRC_VER_SUFFIX}

#定义压缩包名称
COMPRESS_PACKAGE=${PACKAGE_NAME}.tar.gz

#定义编译后安装--生成的文件,文件夹位置路径
INSTALL_PATH=/opt/${PACKAGE_NAME}

#添加交叉编译工具链路径 
# CROSS_CHAIN_PREFIX=/opt/arm-gcc/bin/arm-linux-gnueabihf
CROSS_CHAIN_PREFIX=/opt/gcc-arm-linux-gnueabihf-8.3.0/bin/arm-linux-gnueabihf

#无需修改--下载地址
DOWNLOAD_LINK=https://sourceware.org/ftp/${MAJOR_NAME}/${COMPRESS_PACKAGE}

#下载源码包
do_download_src () {
   echo "\033[1;33mstart download ${PACKAGE_NAME}...\033[0m"

   if [ ! -f "${COMPRESS_PACKAGE}" ];then
      if [ ! -d "${PACKAGE_NAME}" ];then
         wget -c ${DOWNLOAD_LINK}
      fi
   fi

   echo "\033[1;33mdone...\033[0m"
}

#解压源码包
do_tar_package () {
   #if exist file then
   echo "\033[1;33mstart unpacking the ${PACKAGE_NAME} package ...\033[0m"
   if [ ! -d "${PACKAGE_NAME}" ];then
      tar -xf ${COMPRESS_PACKAGE}
   fi
   echo "\033[1;33mdone...\033[0m"
   cd ${PACKAGE_NAME}
}

#配置选项
do_configure () {
   echo "\033[1;33mstart configure ${PACKAGE_NAME}...\033[0m"

   export CC=${CROSS_CHAIN_PREFIX}-gcc 
   export LD=${CROSS_CHAIN_PREFIX}-ld 
   export AR=${CROSS_CHAIN_PREFIX}-ar 
   export AS=${CROSS_CHAIN_PREFIX}-as 
   export RANLIB=${CROSS_CHAIN_PREFIX}-ranlib 
   
   ./configure --prefix=${INSTALL_PATH} --host=${PLATFORM}

   echo "\033[1;33mdone...\033[0m"
}


#编译并且安装
do_make_install () {
   echo "\033[1;33mstart make and install ${PACKAGE_NAME} ...\033[0m"
   make && make install
   echo "\033[1;33mdone...\033[0m"
}

#删除下载的文件
do_delete_file () {
   cd ${SCRIPT_PATH}
   if [ -f "${PACKAGE_NAME}" ];then
      sudo rm -f ${PACKAGE_NAME}
   fi
}

do_download_src
do_tar_package
do_configure
do_make_install
# do_delete_file

exit $?
