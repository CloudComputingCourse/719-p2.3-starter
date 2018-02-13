#!/bin/sh

PROJ_PATH=`dirname $0`

/root/spark/bin/spark-submit $PROJ_PATH/spark_sparse_lr.py $1 $2 $3 $4 $5
