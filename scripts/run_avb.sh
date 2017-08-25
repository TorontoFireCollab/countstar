#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "Need 3 arguments: tablea, tableb and margin" >&2
  exit 1
fi

cp /home/kecai/w49/sql/avb.sql  /home/kecai/w49/sql/avb.sql.$1$2
SQLSCRIPT=/home/kecai/w49/sql/avb.sql.$1$2
SUFFIX=`echo $3 | sed 's/0\.//g'`

sed -i "s/TBA/$1/g" $SQLSCRIPT
sed -i "s/TBB/$2/g" $SQLSCRIPT
sed -i "s/MARGIN/$3/g" $SQLSCRIPT
sed -i "s/SUFFIX/$SUFFIX/g" $SQLSCRIPT

#cat $SQLSCRIPT
sqlite3 w49.db ".read $SQLSCRIPT"
