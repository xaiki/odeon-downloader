#!/bin/sh
base=10
pack=`printf "%04d" $(($1*$base))`

mkdir -p packs
ls data/*/get.url | head -$pack | tail -$base | while read u; do
        d=`echo $u | sed s/'\/get.url'//`;
        v="$d/video.ts";

        echo mkdir -p $d
        echo ffmpeg -i `cat $u` -acodec copy -vcodec copy -copyts $v;
done > packs/pack-$pack.sh

