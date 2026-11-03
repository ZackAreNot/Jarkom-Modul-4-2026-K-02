#!/bin/sh
# MyuMyu - 30 host, subnet A1 (192.212.28.0/25), terhubung ke Cyberia lewat Switch1
# Simpan sebagai /root/MyuMyu.sh lalu jalankan: sh /root/MyuMyu.sh

ip addr flush dev eth0 2>/dev/null || true
ip route flush all 2>/dev/null || true

ip addr replace 192.212.28.3/25 dev eth0
ip link set eth0 up
ip route replace default via 192.212.28.1   # gateway: Cyberia

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# Persistensi saat reboot
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.28.3
    netmask 255.255.255.128
    gateway 192.212.28.1
EOF

grep -q "/root/MyuMyu.sh" /root/.bashrc 2>/dev/null || echo "sh /root/MyuMyu.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] MyuMyu siap!"
