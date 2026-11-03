#!/bin/sh
# Eiri - Host Sayap Bawah
# Simpan sebagai /root/Eiri.sh lalu jalankan: sh /root/Eiri.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.16.130/29 dev eth0
ip link set eth0 up
ip route replace default via 192.212.16.129

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.16.130
    netmask 255.255.255.248
    gateway 192.212.16.129
NETEOF

grep -q "/root/Eiri.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Eiri.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Eiri siap!"
