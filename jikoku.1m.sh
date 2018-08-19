#!/bin/sh
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

echo "⏲"
echo "---"

go_filter=""
return_filter="筑 唐 津"
go_base="https://transit.yahoo.co.jp/station/time/28074/?gid=2480"
return_base="https://transit.yahoo.co.jp/station/time/28253/?gid=6400"

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
    filter=$go_filter
    echo "Go | href=$url"
else
    url="${return_base}&kind=${kind}"
    filter=$return_filter
    echo "Return | href=$url"
fi

echo "---"

jikoku -u "${url}" -f "${filter}"

echo "---"
echo "Refresh | refresh=true"
