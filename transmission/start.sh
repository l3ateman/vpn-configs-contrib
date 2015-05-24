#!/bin/sh

tun0ip=$(ifconfig tun0 | sed -n '2 p' | awk '{print $2}' | cut -d: -f2)
echo "Updating TRANSMISSION_BIND_ADDRESS_IPV4 to tun0 ip: ${tun0ip}"
export TRANSMISSION_BIND_ADDRESS_IPV4=${tun0ip}

echo "Generating transmission settings.json from env variables"
dockerize -template /etc/transmission-daemon/settings.tmpl:/etc/transmission-daemon/settings.json /bin/true

echo "STARTING TRANSMISSION"
exec /usr/bin/transmission-daemon -g /etc/transmission-daemon/ &

echo "STARTING PORT UPDATER"
exec /etc/transmission-daemon/startPortUpdates.sh &

echo "Transmission startup script complete."
