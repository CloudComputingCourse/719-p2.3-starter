#!/bin/sh
# -------- BEGIN: DON'T CHANGE --------
export HADOOP_HOME=$HOME/hadoop
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native

echo "Hadoop homedir: $HADOOP_HOME"

PROJ_PATH=`dirname $0`
ETL_SCRIPT="$PROJ_PATH/spark_sparse_lr.py"
# -------- END: DON'T CHANGE --------

# TODO (students): write your script with defined variables

master_url=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`

spark-submit \
    --conf spark.eventLog.enabled=true \
    --deploy-mode client \
    --master spark://$master_url:7077 \
    $ETL_SCRIPT $1 $2 $3 $4 $5
