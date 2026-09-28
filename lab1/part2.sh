#!/bin/bash

set -e

REAL_IF="enp0s8"
REAL_CON="lab-static"

DUMMY_IF="dm0"
DUMMY_CON="dm0"

echo "...clean old connections"

for CON in "$REAL_CON" "$DUMMY_CON" "dummy-dm0"
do
    if nmcli -t -f NAME connection show | grep -Fxq "$CON"; then
        sudo nmcli connection delete "$CON"
    fi
done

echo
echo "...configure $REAL_IF"

sudo nmcli connection add \
    type ethernet \
    ifname "$REAL_IF" \
    con-name "$REAL_CON" \
    ipv4.method manual \
    ipv4.addresses 10.100.0.2/24 \
    ipv4.gateway 10.100.0.1 \
    ipv4.dns 8.8.8.8 \
    ipv4.route-metric 500

sudo nmcli connection up "$REAL_CON"

echo
echo "...creating dummy interface $DUMMY_IF"

sudo nmcli connection add \
    type dummy \
    ifname "$DUMMY_IF" \
    con-name "$DUMMY_CON" \
    ipv4.method manual \
    ipv4.addresses 10.100.0.3/24 \
    ipv4.never-default yes

sudo nmcli connection up "$DUMMY_CON"

echo
echo "---network devices"
nmcli device status

echo
echo "--- $REAL_IF IPv4"
ip -4 addr show "$REAL_IF"

echo
echo "--- $DUMMY_IF IPv4"
ip -4 addr show "$DUMMY_IF"

echo
echo "--- $DUMMY_IF MAC"
cat /sys/class/net/"$DUMMY_IF"/address

echo
echo "--- Routes"
ip route