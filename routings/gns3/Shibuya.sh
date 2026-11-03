#!/bin/sh
for i in eth0 eth1; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.16.102/30 dev eth0   # A24 (ke Phantoma)
ip link set eth0 up
ip addr replace 192.212.16.1/26 dev eth1     # A25 (Switch13: Lain, Mika)
ip link set eth1 up

ip route replace default via 192.212.16.101  # Default ke Phantoma

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.16.102
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.16.1
    netmask 255.255.255.192
NETEOF
grep -q "/root/Shibuya.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Shibuya.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Shibuya siap!"
