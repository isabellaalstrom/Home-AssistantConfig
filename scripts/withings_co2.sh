#!/bin/bash
#Instructions https://community.home-assistant.io/t/withings-scales/4853/13?u=jscolp
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null
USERNAME=$(cat $SCRIPTPATH/secrets.txt | cut -d , -f1)
PASSWORD=$(cat $SCRIPTPATH/secrets.txt | cut -d , -f2)
CURUSER=$(cat $SCRIPTPATH/secrets.txt | cut -d , -f3)
DEVICEID=$(cat $SCRIPTPATH/secrets.txt | cut -d , -f4)

#Authenticate
curl -s -c $SCRIPTPATH/cookies.txt -b $SCRIPTPATH/cookies.txt 'https://account.withings.com/connectionuser/account_login?appname=my2&appliver=e5ed95dd&r=https%3A%2F%2Fhealthmate.withings.com%2F' -H 'Origin: https://account.withings.com' -H 'Referer: https://account.withings.com/connectionuser/account_login?appname=my2&appliver=e5ed95dd&r=https%3A%2F%2Fhealthmate.withings.com%2F' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'email='"$USERNAME"'&password='"$PASSWORD"'&is_admin=' --compressed > /dev/null
#Grab Session
SESSIONKEY=$(cat $SCRIPTPATH/cookies.txt | grep session | cut -f7 -d$'\t')
#Grab CO2
curl -s -c $SCRIPTPATH/cookies.txt -b $SCRIPTPATH/cookies.txt "https://healthmate.withings.com/index/service/v2/measure" -H "Cookie: session_key="$SESSIONKEY"; current_user="$CURUSER"" -H 'Origin: https://healthmate.withings.com' --data "sessionid="$SESSIONKEY"&meastype=12"%"2C35&deviceid="$DEVICEID"&appname=my2&appliver=a9467957&apppfm=web&action=getmeashf" | jq .body.series[1].data[-1].value