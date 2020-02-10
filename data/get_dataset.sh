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

echo "Using /data as cache"
#mkdir -p /root/tmp
#cd /root/tmp
cd /data

if [ "${1}" == "A" ]; then
    DATA_URL=https://s3.amazonaws.com/cmucc-datasets/kdd10.gz
    LOCAL_ZIP_PATH=kdd10.gz
    LOCAL_UNZIP_PATH=kdd10
    UNZIP_CMD="gunzip -f > ${LOCAL_UNZIP_PATH}"
    HDFS_PATH=/kdd10
    DATA_SIZE=2670162192
elif [ "${1}" == "B" ]; then
    DATA_URL=https://s3.amazonaws.com/cmucc-datasets/kdd12.gz
    LOCAL_ZIP_PATH=kdd12.gz
    LOCAL_UNZIP_PATH=kdd12
    UNZIP_CMD="gunzip -f > ${LOCAL_UNZIP_PATH}"
    HDFS_PATH=/kdd12
    DATA_SIZE=22475194880
else
    DATA_URL=https://s3.amazonaws.com/cmucc-datasets/criteo_4percent_719proj2.tar.gz
    LOCAL_ZIP_PATH=criteo_4percent_719proj2.tar.gz
    LOCAL_UNZIP_PATH=criteo_4percent_719proj2
    UNZIP_CMD="tar zxf -"
    HDFS_PATH=/criteo
    DATA_SIZE=38273141584
fi

if [ -f $LOCAL_UNZIP_PATH ]; then
  SIZE_IN_CACHE=$(ls -l $LOCAL_UNZIP_PATH | awk '{print $5 }')
elif [ -d $LOCAL_UNZIP_PATH ]; then
  SIZE_IN_CACHE=$(du -sb $LOCAL_UNZIP_PATH | awk '{print $1 }')
else
  SIZE_IN_CACHE=999 # hopefully this doesn't match any dataset
fi

echo $SIZE_IN_CACHE, $DATA_SIZE

if [ $SIZE_IN_CACHE == $DATA_SIZE ]; then
  echo "Cache Hit: ${LOCAL_ZIP_PATH}. Not downloading again."
else
  echo "Cache Miss: ${LOCAL_ZIP_PATH}. Downloading again."
  echo "Install pv"
  sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm || /bin/true
  sudo yum install pv || /bin/true

  echo "Downloading dataset"
  rm -f ${LOCAL_ZIP_PATH}
  wget ${DATA_URL}

  echo "Decompressing dataset"
  #${UNZIP_CMD} ${UNZIP_OPT} ${LOCAL_ZIP_PATH}
  rm -rf ${LOCAL_UNZIP_PATH}
  pv ${LOCAL_ZIP_PATH} | $(eval ${UNZIP_CMD}) 
fi

echo "Copying to HDFS...This can take a while, please wait.."
hdfs dfs -rm -r -f ${HDFS_PATH} > /dev/null 2>&1
hdfs dfs -copyFromLocal -f ${LOCAL_UNZIP_PATH} ${HDFS_PATH}
