#!/bin/bash
set -e

home_path="$(pwd)"

# sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list
echo "*************Start to install ssh **************"
sudo apt-get update || true && apt-get install -y openssh-server wget python-pip python-dev curl

echo "*************Start to install JAVA **************"
#install java by yourself

tar -xzf jdk-8u171-linux-x64.tar.gz
sudo mv ./jdk1.8.0_171 /opt/jdk1.8.0_171
echo "*************Start to download hadoop**************"
wget "https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-xxx/hadoop-xxx.tar.gz"
tar -xzf hadoop-xxx.tar.gz

str="HADOOP_NAME=hadoop-xxx\nJAVA_HOME=/opt/jdk1.8.0_xxx\nHADOOP_HOME=${home_path}/\${HADOOP_NAME}\nPATH=\$PATH:${home_path}/\${HADOOP_NAME}/bin:${home_path}/\${HADOOP_NAME}/sbin:\${JAVA_HOME}/bin \nPROFILE_PATH=${home_path}/profile"
export HADOOP_NAME=hadoop-xxx
export JAVA_HOME=/opt/jdk1.8.0_xxx
export HADOOP_HOME=${home_path}/${HADOOP_NAME}
export PATH=$PATH:${home_path}/${HADOOP_NAME}/bin:${home_path}/${HADOOP_NAME}/sbin:${JAVA_HOME}/bin


echo -e $str >> ~/.bashrc #这里自己写
source ~/.bashrc

mkdir -p ~/hdfs/namenode
mkdir -p ~/hdfs/datanode
mkdir $HADOOP_HOME/logs

echo "*************Change hadoop config **************"
# mv ./config/* 

mv ./config/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
mv ./config/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
mv ./config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
mv ./config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
mv ./config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
mv ./config/stop-yarn.sh ${HADOOP_HOME}/sbin/stop-yarn.sh
mv ./config/start-yarn.sh ${HADOOP_HOME}/sbin/start-yarn.sh
mv ./config/start-dfs.sh ${HADOOP_HOME}/sbin/start-dfs.sh
mv ./config/stop-dfs.sh ${HADOOP_HOME}/sbin/stop-dfs.sh
# cp ./config/slaves $HADOOP_HOME/etc/hadoop/slaves


chmod +x ${HADOOP_HOME}/sbin/start-dfs.sh
chmod +x ${HADOOP_HOME}/sbin/start-yarn.sh
chmod +x ${HADOOP_HOME}/sbin/stop-dfs.sh
chmod +x ${HADOOP_HOME}/sbin/stop-yarn.sh