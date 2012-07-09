#!/bin/sh
HOST=$1
USER=$2
PASS=$3
DEST_FOLDER=$4
SOURCE_FOLDER=$5
for filename in $SOURCE_FOLDER/*
do
  ncftpput -R -u $USER -p $PASS $HOST $DEST_FOLDER $filename
done;