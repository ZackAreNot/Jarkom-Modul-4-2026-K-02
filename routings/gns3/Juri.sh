#!/bin/sh
# Juri - Host Sayap Kiri
# Simpan sebagai /root/Juri.sh lalu jalankan: sh /root/Juri.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.14.2/26 dev eth0
ip link set eth0 up
ip route replace default via 192.212.14.1

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.14.2
    netmask 255.255.255.192
    gateway 192.212.14.1
NETEOF

grep -q "/root/Juri.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Juri.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Juri siap!"
