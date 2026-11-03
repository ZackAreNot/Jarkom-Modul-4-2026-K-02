#!/bin/sh
for i in eth0 eth1; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.14.66/29 dev eth0
ip link set eth0 up
ip addr replace 192.212.8.1/22 dev eth1
ip link set eth1 up

ip route replace default via 192.212.14.65

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.14.66
    netmask 255.255.255.248
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.8.1
    netmask 255.255.252.0
NETEOF
grep -q "/root/Psyche.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Psyche.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Psyche siap!"
