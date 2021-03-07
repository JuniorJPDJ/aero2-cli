#!/bin/sh
set -e

captcha_file="$1"

notify_id=`gdbus call \
	--session --dest=org.freedesktop.Notifications \
	--object-path=/org/freedesktop/Notifications \
	--method=org.freedesktop.Notifications.Notify \
	"aero2" 0 "" 'New captcha' \
	'<img src="file://'"$captcha_file"'" alt="captcha"/>' \
	'["inline-reply", "Send"]' \
	'{"urgency": <2>}' 0 | awk '{print $2}' | awk -F, '{print $1}'`

out=`mktemp`
trap "rm -f $out" EXIT
rm "$out"
mkfifo -m 600 "$out"

dbus-monitor "type='signal',interface='org.freedesktop.Notifications'" > "$out" &
dbus_monitor_pid=$!
trap "kill $dbus_monitor_pid; rm -f $out" EXIT

{
	while read -r event ; do
		#echo $event
		case "$event" in
			signal*member=NotificationReplied)
				read -r nid
				read -r text

				nid="${nid:7}"
				text="${text:8:$((${#text}-9))}"
					#echo replied: $notify_id $nid $text
				
				[ "$notify_id" == "$nid" ] && echo "$text"
				;;

			signal*member=NotificationClosed)
				read -r nid
				read -r reason

				nid="${nid:7}"
				reason="${nid:7}"

				#echo closed: $nid $reason

				[ "$notify_id" == "$nid" ] && break
				;;
		esac
	done
} < "$out"
