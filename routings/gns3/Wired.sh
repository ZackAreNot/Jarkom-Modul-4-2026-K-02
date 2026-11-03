#!/bin/sh
# Wired - Router Backbone
# Simpan sebagai /root/Wired.sh lalu jalankan: sh /root/Wired.sh
#
# eth0 -> Cyberia                                A2   192.212.28.130/30
# eth1 -> Switch2 (Psyche, Copland, Schumann)    A3   192.212.14.65/29
# eth2 -> Tachibana                              A14  192.212.22.1/30
# eth3 -> Navi                                   A10  192.212.25.65/30

# 1. Reset konfigurasi lama
for i in eth0 eth1 eth2 eth3; do ip addr flush dev $i 2>/dev/null || true; done
ip route flush all 2>/dev/null || true

# 2. Aktifkan IP forwarding
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

# 3. IP tiap interface
ip addr replace 192.212.28.130/30 dev eth0   # A2
ip link set eth0 up
ip addr replace 192.212.14.65/29 dev eth1   # A3
ip link set eth1 up
ip addr replace 192.212.22.1/30 dev eth2   # A14
ip link set eth2 up
ip addr replace 192.212.25.65/30 dev eth3   # A10
ip link set eth3 up

# 4. Routing Supernet (CIDR Agregat)
ip route replace default via 192.212.28.129   # Default ke Cyberia
ip route replace 192.212.8.0/22 via 192.212.14.66   # Blok Psyche
ip route replace 192.212.12.0/22 via 192.212.14.67   # Blok Copland
ip route replace 192.212.0.0/21 via 192.212.14.68   # Blok Schumann
ip route replace 192.212.24.0/22 via 192.212.25.66   # Blok Kanan / Navi
ip route replace 192.212.16.0/21 via 192.212.22.2   # Blok Bawah / Tachibana

# 5. DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# 6. Persistensi
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.28.130
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1

auto eth1
iface eth1 inet static
    address 192.212.14.65
    netmask 255.255.255.248

auto eth2
iface eth2 inet static
    address 192.212.22.1
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 192.212.25.65
    netmask 255.255.255.252
EOF

grep -q "/root/Wired.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Wired.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Wired siap!"
