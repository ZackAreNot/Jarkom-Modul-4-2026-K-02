#!/bin/sh
# Hodgeson - Host Sayap Bawah
# Simpan sebagai /root/Hodgeson.sh lalu jalankan: sh /root/Hodgeson.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.17.3/26 dev eth0
ip link set eth0 up
ip route replace default via 192.212.17.1

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.17.3
    netmask 255.255.255.192
    gateway 192.212.17.1
NETEOF

grep -q "/root/Hodgeson.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Hodgeson.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Hodgeson siap!"
