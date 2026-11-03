#!/bin/sh
# Cyberia - Router Gateway Internet
# Simpan sebagai /root/Cyberia.sh lalu jalankan: sh /root/Cyberia.sh
#
# eth0 -> NAT1 (internet)
# eth1 -> Switch1 (JJ, MyuMyu)                   A1   192.212.28.1/25
# eth2 -> Wired                                  A2   192.212.28.129/30

# 1. Reset konfigurasi lama
for i in eth0 eth1 eth2; do ip addr flush dev $i 2>/dev/null || true; done
ip route flush all 2>/dev/null || true

# 2. Aktifkan IP forwarding (router)
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true

# 3. Interface WAN (eth0 -> NAT1)
ip link set eth0 up

# Coba ambil via DHCP dengan script handler
cat << 'EOF' > /etc/udhcpc.script
#!/bin/sh
[ "$1" = "bound" ] || [ "$1" = "renew" ] || exit 0
ip addr replace $ip/$mask dev $interface 2>/dev/null || true
[ -n "$router" ] && ip route replace default via $router dev $interface 2>/dev/null || true
[ -n "$dns" ] && echo "nameserver $dns" > /etc/resolv.conf
EOF
chmod +x /etc/udhcpc.script
udhcpc -i eth0 -s /etc/udhcpc.script -n -q 2>/dev/null || dhclient eth0 2>/dev/null || true

# Fallback ke IP statis NAT GNS3 jika DHCP tidak mendapatkan default route
if ! ip route | grep -q "default"; then
    echo "[!] Menggunakan IP statis fallback untuk NAT GNS3 (192.168.122.50)..."
    ip addr replace 192.168.122.50/24 dev eth0
    ip route replace default via 192.168.122.1
fi

# 4. IP tiap interface internal
ip addr replace 192.212.28.1/25 dev eth1   # A1 (Switch1)
ip link set eth1 up
ip addr replace 192.212.28.129/30 dev eth2   # A2 (Wired)
ip link set eth2 up

# 5. Routing ke seluruh The Wired
ip route replace 192.212.0.0/19 via 192.212.28.130   # J1: seluruh The Wired (root /19), via Wired

# 6. NAT Masquerade
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# 7. DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# 8. Persistensi saat reboot
grep -q "/root/Cyberia.sh" /root/.bashrc 2>/dev/null || echo "sh /root/Cyberia.sh >/dev/null 2>&1" >> /root/.bashrc

echo "[OK] Cyberia berhasil dikonfigurasi!"
