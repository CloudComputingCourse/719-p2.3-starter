#!/bin/bash
# Downloads the machine learning dataset and places it in HDFS
# ARGS:
# $1 N - The dataset for test case N (A, B, or C)

set -e
if [[ -z ${1+x} || ("${1}" != "A" && "${1}" != "B" && "${1}" != "C") ]]; then    
    echo "USAGE"
    echo '$1 N - The dataset for test case N (A, B, or C)'
    exit
fi

echo "Creating /root/tmp dir"
mkdir -p /root/tmp
cd /root/tmp

if [ "${1}" == "A" ]; then
    DATA_URL=https://s3.amazonaws.com/719-project2-east1/kdd10.gz
    LOCAL_ZIP_PATH=kdd10.gz
    LOCAL_UNZIP_PATH=kdd10
    UNZIP_CMD="gunzip -f -k > ${LOCAL_UNZIP_PATH}"
    HDFS_PATH=/kdd10
elif [ "${1}" == "B" ]; then
    DATA_URL=https://s3.amazonaws.com/719-project2-east1/kdd12.gz
    LOCAL_ZIP_PATH=kdd12.gz
    LOCAL_UNZIP_PATH=kdd12
    UNZIP_CMD="gunzip -f -k > ${LOCAL_UNZIP_PATH}"
    HDFS_PATH=/kdd12
else
    DATA_URL=https://s3.amazonaws.com/719-project2-east1/criteo_4percent_719proj2.tar.gz
    LOCAL_ZIP_PATH=criteo_4percent_719proj2.tar.gz
    LOCAL_UNZIP_PATH=criteo_4percent_719proj2
    UNZIP_CMD="tar zxf -"
    HDFS_PATH=/criteo
fi

echo "Install pv"
sudo apt-get install pv

echo "Downloading dataset"
rm -f ${LOCAL_ZIP_PATH}
wget ${DATA_URL}

echo "Decompressing dataset"
#${UNZIP_CMD} ${UNZIP_OPT} ${LOCAL_ZIP_PATH}
rm -rf ${LOCAL_UNZIP_PATH}
pv ${LOCAL_ZIP_PATH} | $(eval ${UNZIP_CMD}) 

echo "Copying to HDFS...This can take a while, please wait.."
/root/hadoop/bin/hdfs dfs -rm -r -f ${HDFS_PATH} > /dev/null 2>&1
/root/hadoop/bin/hdfs dfs -copyFromLocal -f ${LOCAL_UNZIP_PATH} ${HDFS_PATH}

echo "Removing local copy"
rm -rf ${LOCAL_UNZIP_PATH}
rm -f ${LOCAL_ZIP_PATH}
