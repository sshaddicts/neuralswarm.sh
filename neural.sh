#!/usr/bin/env bash

head='{"procedure":"process.image", "args":[], "kwargs": { "image":"'
tail='", "token":"anonymous" }}'

function json(){
    bash ./JSON.sh/JSON.sh "$@"
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            exit
            ;;
        -u | --url)
            URL=$VALUE
            ;;
        -i | --image)
            IMAGE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""

            exit 1
            ;;
    esac
    shift
done

if [ -z ${URL+x} ]; then echo "--url is not set"; exit; fi

if [ -z ${IMAGE+x} ]; then echo "--image is not set"; exit; fi

image=`cat ${IMAGE} | base64`

request=${head}${image}${tail}

echo ${request} | curl -s -X POST ${URL} -H 'content-type: application/json' -d @- \
| json -b | grep kwargs | sed -e 's/"kwargs",//g'