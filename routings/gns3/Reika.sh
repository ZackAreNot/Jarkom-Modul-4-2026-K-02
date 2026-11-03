#!/bin/sh
# Reika - Host Sayap Kanan (Navi)
# Simpan sebagai /root/Reika.sh lalu jalankan: sh /root/Reika.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.24.3/24 dev eth0
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
    address 192.212.24.3
    netmask 255.255.255.0
    gateway 192.212.24.1
NETEOF

grep -q "/root/Reika.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Reika.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Reika siap!"
