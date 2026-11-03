#!/bin/sh
# Alice - Host Sayap Kanan (Navi)
# Simpan sebagai /root/Alice.sh lalu jalankan: sh /root/Alice.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.24.2/24 dev eth0
ip link set eth0 up
ip route replace default via 192.212.24.1

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Persistensi saat restart
cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.24.2
    netmask 255.255.255.0
    gateway 192.212.24.1
NETEOF

grep -q "/root/Alice.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Alice.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Alice siap!"
