#!/bin/sh
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

echo ":train:"
echo "---"

go_filter=""
return_filter="筑 西 唐"
go_base="http://transit.yahoo.co.jp/station/time/28074/?gid=2480"
return_base="http://transit.yahoo.co.jp/station/time/28236/?gid=6400"

day=`date "+%a"`
hour=`date "+%H"`

if [ $hour -lt 13 ]; then
    go=true
else
    go=false
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

if [ $go = true ]; then
    url="${go_base}&kind=${kind}"
    path="/tmp/jikoku_go_${kind}"
    filter=$go_filter
    echo "Go | href=$url"
else
    url="${return_base}&kind=${kind}"
    path="/tmp/jikoku_return_${kind}"
    filter=$return_filter
    echo "Return | href=$url"
fi

if [ ! -f ${path} ] && [ ! -s ${path} ]; then
    curl -s ${url} -o ${path}
else
    current=`date +%s`
    last_modified=`stat -f "%m" ${path}`
    if [ $(($current - $last_modified)) -gt 3600 ]; then
        curl -s ${url} -o ${path}
    fi
fi

echo "---"

cat ${path} |\
    pup 'table.tblDiaDetail [id*="hh_"] json{}' |\
    jq '[.[] | { hour: .children[0].text, minutes: [.children[1].children[].children[].children[].children[].children | map(.text) | join(" ") ] }]' |\
    jikoku -f "${filter}"

echo "---"
echo "Refresh | refresh=true"
