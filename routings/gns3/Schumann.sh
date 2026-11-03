#!/bin/sh
for i in eth0 eth1 eth2; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.14.68/29 dev eth0
ip link set eth0 up
ip addr replace 192.212.4.1/29 dev eth1
ip link set eth1 up
ip addr replace 192.212.4.9/30 dev eth2
ip link set eth2 up

ip route replace default via 192.212.14.65
ip route replace 192.212.0.0/22 via 192.212.4.10

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.14.68
    netmask 255.255.255.248
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.4.1
    netmask 255.255.255.248
auto eth2
iface eth2 inet static
    address 192.212.4.9
    netmask 255.255.255.252
NETEOF
grep -q "/root/Schumann.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Schumann.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Schumann siap!"
