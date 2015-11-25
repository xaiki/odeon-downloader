#!/bin/sh

INCAA_KEY=`cat incaa.key`;
INCAA_PERFIL=`cat incaa.perfil`;

set -x
cd data && for i in `echo $@ || seq 100000`; do
        curl "https://www.odeon.com.ar/INCAA/prod/$i?perfil=$INCAA_PERFIL" -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H "Authorization: Bearer $INCAA_KEY" -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://www.odeon.com.ar/' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed | jsonlint > data.json
        if (cat data.json | grep \"tit\") then
           title=`cat data.json | grep \"tit\" | head -1 | cut -d\" -f4`
           titlep=`echo $title | sed s/' '/'_'/g`;
           d="$i-$titlep";
           mkdir -p "$i-$titlep" && mv data.json $d;
           (cd $d &&
                       surl=`curl "https://player.odeon.com.ar/odeon/?i=$i&p=$INCAA_PERFIL&s=INCAA&t=$INCAA_KEY" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.odeon.com.ar/' -H 'Connection: keep-alive' --compressed | grep "file: 'http" | cut -d"'" -f2 | sed s/"'"//` &&
                       echo "$surl" > get.url;
            #ffmpeg -i "$surl" -acodec copy -vcodec copy -copyts $titlep.ts
           )
        fi
done
