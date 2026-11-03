#!/bin/sh
for i in eth0 eth1 eth2; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.18.130/30 dev eth0   # A16 (ke Tachibana)
ip link set eth0 up
ip addr replace 192.212.18.1/25 dev eth1     # A17 (Switch10: Lilith, Specter)
ip link set eth1 up
ip addr replace 192.212.17.65/30 dev eth2    # A18 (ke Protocol7)
ip link set eth2 up

ip route replace default via 192.212.18.129         # Default ke Tachibana
ip route replace 192.212.16.0/23 via 192.212.17.66  # Rute Blok Protocol7

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.18.130
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.18.1
    netmask 255.255.255.128
auto eth2
iface eth2 inet static
    address 192.212.17.65
    netmask 255.255.255.252
NETEOF
grep -q "/root/Deus.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Deus.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Deus siap!"
