#!/bin/sh
# Navi - Router Sayap Kanan
# Simpan sebagai /root/Navi.sh lalu jalankan: sh /root/Navi.sh
#
# eth0 -> Wired                                  A10  192.212.25.66/30
# eth1 -> Switch6 (Alice, Reika)                 A11  192.212.24.1/24
# eth2 -> Switch7 (Taro)                         A12  192.212.25.1/26
# eth3 -> Switch8 (Yasuo, Miho, Kuma)            A13  192.212.26.1/24

# 1. Reset konfigurasi lama
for i in eth0 eth1 eth2 eth3; do ip addr flush dev $i 2>/dev/null || true; done
ip route flush all 2>/dev/null || true

# 2. Aktifkan IP forwarding
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

# 3. IP tiap interface
ip addr replace 192.212.25.66/30 dev eth0   # A10 (ke Wired)
ip link set eth0 up
ip addr replace 192.212.24.1/24 dev eth1    # A11 (Switch6)
ip link set eth1 up
ip addr replace 192.212.25.1/26 dev eth2    # A12 (Switch7)
ip link set eth2 up
ip addr replace 192.212.26.1/24 dev eth3    # A13 (Switch8)
ip link set eth3 up

# 4. Routing
ip route replace default via 192.212.25.65   # Default ke router atas (Wired)

# 5. DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# 6. Persistensi saat reboot
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.25.66
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1

auto eth1
iface eth1 inet static
    address 192.212.24.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.212.25.1
    netmask 255.255.255.192

auto eth3
iface eth3 inet static
    address 192.212.26.1
    netmask 255.255.255.0
EOF

grep -q "/root/Navi.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Navi.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Navi siap!"
