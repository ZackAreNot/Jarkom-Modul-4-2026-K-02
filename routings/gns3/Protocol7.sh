#!/bin/sh
for i in eth0 eth1 eth2; do ip addr flush dev  2>/dev/null || true; done
ip route flush all 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

ip addr replace 192.212.17.66/30 dev eth0    # A18 (ke Deus)
ip link set eth0 up
ip addr replace 192.212.17.1/26 dev eth1     # A19 (Switch11: Chisa, Hodgeson)
ip link set eth1 up
ip addr replace 192.212.16.137/30 dev eth2   # A20 (ke Knights)
ip link set eth2 up

ip route replace default via 192.212.17.65          # Default ke Deus
ip route replace 192.212.16.0/24 via 192.212.16.138 # Rute Blok Knights

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

cat << 'NETEOF' > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.17.66
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.17.1
    netmask 255.255.255.192
auto eth2
iface eth2 inet static
    address 192.212.16.137
    netmask 255.255.255.252
NETEOF
grep -q "/root/Protocol7.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Protocol7.sh >/dev/null 2>&1" >> /root/.bashrc
echo "[OK] Protocol7 siap!"
