#!/bin/sh
for i in eth0 eth1 eth2; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.16.138/30 dev eth0   # A20 (ke Protocol7)
ip link set eth0 up
ip addr replace 192.212.16.129/29 dev eth1   # A21 (Direct ke Eiri)
ip link set eth1 up
ip addr replace 192.212.16.97/30 dev eth2    # A22 (ke Phantoma)
ip link set eth2 up

ip route replace default via 192.212.16.137         # Default ke Protocol7
ip route replace 192.212.16.0/25 via 192.212.16.98  # Rute Blok Phantoma

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.16.138
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.16.129
    netmask 255.255.255.248
auto eth2
iface eth2 inet static
    address 192.212.16.97
    netmask 255.255.255.252
NETEOF
grep -q "/root/Knights.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Knights.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Knights siap!"
