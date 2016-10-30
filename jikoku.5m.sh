#!/bin/zsh

echo ":train:"
echo "---"

day=`date "+%a"`
hour=`date "+%H"`
filter='筑 西 唐'

if [ $hour -lt 13 ]; then
    url="http://transit.yahoo.co.jp/station/time/28074/?gid=2480"
else
    url="http://transit.yahoo.co.jp/station/time/28236/?gid=6400"
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

url="${url}&kind=${kind}"

curl -s "${url}" |\
    /usr/local/bin/pup 'table.tblDiaDetail [id*="hh_"] json{}' |\
    /usr/local/bin/jq '[.[] | { hour: .children[0].text, minutes: [.children[1].children[].children[].children[].children[].children | map(.text) | join(" ") ] }]' |\
    /Users/morygonzalez/src/github.com/morygonzalez/commute-timer/jikoku -f "${filter}"

echo "---"
echo "Refresh | refresh=true"
