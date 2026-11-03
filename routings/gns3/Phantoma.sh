#!/bin/sh
for i in eth0 eth1 eth2; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.16.98/30 dev eth0    # A22 (ke Knights)
ip link set eth0 up
ip addr replace 192.212.16.65/27 dev eth1    # A23 (Switch12: Semi)
ip link set eth1 up
ip addr replace 192.212.16.101/30 dev eth2   # A24 (ke Shibuya)
ip link set eth2 up

ip route replace default via 192.212.16.97           # Default ke Knights
ip route replace 192.212.16.0/26 via 192.212.16.102  # Rute LAN Shibuya

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.16.98
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.16.65
    netmask 255.255.255.224
auto eth2
iface eth2 inet static
    address 192.212.16.101
    netmask 255.255.255.252
NETEOF
grep -q "/root/Phantoma.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Phantoma.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Phantoma siap!"
