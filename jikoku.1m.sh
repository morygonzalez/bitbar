#!/bin/zsh

echo ":train:"
echo "---"

day=`date "+%a"`
hour=`date "+%H"`
filter='筑 西 唐'

if [ $hour -lt 13 ]; then
    base="http://transit.yahoo.co.jp/station/time/28074/?gid=2480"
else
    base="http://transit.yahoo.co.jp/station/time/28236/?gid=6400"
fi

case ${day} in
    "Sun")
        kind=4
    ;;
    "Sat")
        kind=2
    ;;
    *)
        kind=1
    ;;
esac

url="${base}&kind=${kind}"

path="/tmp/jikoku_${kind}"

if [ ! -f ${path} ] && [ ! -s ${path} ]; then
    /usr/bin/curl -s ${url} -o ${path}
else
    current=`/bin/date +%s`
    last_modified=`/usr/bin/stat -f "%m" ${path}`
    if [ $(($current - $last_modified)) -gt 3600 ]; then
        /usr/bin/curl -s ${url} -o ${path}
    fi
fi

/bin/cat ${path} |\
    /usr/local/bin/pup 'table.tblDiaDetail [id*="hh_"] json{}' |\
    /usr/local/bin/jq '[.[] | { hour: .children[0].text, minutes: [.children[1].children[].children[].children[].children[].children | map(.text) | join(" ") ] }]' |\
    /Users/morygonzalez/src/github.com/morygonzalez/jikoku/jikoku -f "${filter}"

echo "---"
echo "Refresh | refresh=true"
