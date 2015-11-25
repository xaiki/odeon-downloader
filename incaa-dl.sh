#!/bin/sh

INCAA_KEY=`cat incaa.key`;
INCAA_PERFIL=`cat incaa.perfil`;

set -x

while read d; do
        (cd $d &&
                    i=`cat data.json | grep \"sid\" | head -1 |cut -d\: -f2 | sed s/' '//g` &&
                    title=`cat data.json | grep \"tit\" | head -1 | cut -d\" -f4` &&
                    titlep=`echo $title | sed s/' '/'_'/g` &&
                    curl "https://player.odeon.com.ar/odeon/?i=$i&p=$INCAA_PERFIL&s=INCAA&t=$INCAA_KEY" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.odeon.com.ar/' -H 'Connection: keep-alive' --compressed > player.page
                    surl=`cat player.page | grep "file: 'http" | cut -d"'" -f2 | sed s/"'"//` &&
                        ffmpeg -i "$surl" -acodec copy -vcodec copy -copyts $titlep.ts
        )
done
