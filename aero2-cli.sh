#!/bin/sh
set -e

# Text-boxes shown by aero2 web page
ALREADY_UNLOCKED="Dostęp do Internetu został odblokowany."
FAILED_CAPTCHA="Niepoprawna odpowiedź."

ns='212.2.127.254'
domain='bdi.free.aero2.net.pl'

function print_alert_box(){
	# echo html | trim spaces in lines | remove newlines | replace DIV and DIV to newlines | cut start and first div, leave div children | leave only div children | remove <br> tags | match div children
	echo "$1" | awk '{$1=$1};1' | tr -d \\n | sed -e 's/DIV/\n/g' -e 's/div/\n/g' | tail -n +5 | head -n 1 | sed 's/<br>//g' | sed 's#.*>\(.*\)<\/.*#\1#'
}

alias a2curl="curl -s --dns-servers "$ns" --connect-timeout 4"

[ "$1" == "" ] && captcha_handler="./aero2-captcha-handler-catimg.sh" || captcha_handler="$1"


form_html=`a2curl "http://$domain:8080/" -d 'viewForm=true'`
box=`print_alert_box "$form_html"`
echo $box
[ "$box" == "$ALREADY_UNLOCKED" ] && return 0

export `echo "$form_html" | grep -m 1 -o -e 'PHPSESSID=[a-z0-9]*'`

tmp=`mktemp`
trap "rm -f $tmp" EXIT
a2curl -o "$tmp" "http://$domain:8080/getCaptcha.html?PHPSESSID=$PHPSESSID"

captcha=`"$captcha_handler" "$tmp"`

rm -f "$tmp"
trap - EXIT

response=`a2curl "http://$domain:8080/" -d 'viewForm=true' -d "captcha=$captcha" -d "PHPSESSID=$PHPSESSID"`

box=`print_alert_box "$response"`
echo $box
[ "$box" == "$FAILED_CAPTCHA" ] && return 1
