#!/bin/bash
# ==============================================================================
# /root/init.sh - Universal Node Initialization & Recovery Script
# Praktikum Jarkom Modul 4 - Kelompok K-02 (Prefix CIDR: 192.212.x.x)
# Layer:04 — The Wired Expansion (Serial Experiments Lain)
#
# Penggunaan:
#   bash /root/init.sh [node_name]
#   (Jika tanpa argumen, otomatis mendeteksi dari hostname)
# ==============================================================================

NODE_NAME="${1:-$(hostname)}"
NODE_LOWER=$(echo "$NODE_NAME" | tr "[:upper:]" "[:lower:]")

set_resolver() {
    cat << "EOF" > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
}

ensure_persistence() {
    if [ -f /root/init.sh ]; then
        grep -q "/root/init.sh" /root/.bashrc 2>/dev/null || echo "bash /root/init.sh >/dev/null 2>&1" >> /root/.bashrc
    fi
}

enable_forwarding() {
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true
    echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-ipforward.conf 2>/dev/null || true
}

echo "=== Mengonfigurasi Node: $NODE_NAME ($NODE_LOWER) ==="

case "$NODE_LOWER" in
    *cyberia*)
        echo "[+] Setup Cyberia..."
        enable_forwarding
        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip link set eth0 up
        cat << "UDEOF" > /etc/udhcpc.script
#!/sh
[ "$1" = "bound" ] || [ "$1" = "renew" ] || exit 0
ip addr replace $ip/$mask dev $interface 2>/dev/null || true
[ -n "$router" ] && ip route replace default via $router dev $interface 2>/dev/null || true
[ -n "$dns" ] && echo "nameserver $dns" > /etc/resolv.conf
UDEOF
        chmod +x /etc/udhcpc.script
        udhcpc -i eth0 -s /etc/udhcpc.script -n -q 2>/dev/null || dhclient eth0 2>/dev/null || true
        if ! ip route | grep -q "default"; then
            ip addr replace 192.168.122.50/24 dev eth0
            ip route replace default via 192.168.122.1
        fi
        iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        ip addr replace 192.212.28.1/25 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.28.129/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.168.122.1
        ip route replace 192.212.0.0/19 via 192.212.28.130
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Cyberia selesai!"
        ;;

    *wired*)
        echo "[+] Setup Wired..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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

        for dev in eth0 eth1 eth2 eth3; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.28.130/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.14.65/29 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.22.1/30 dev eth2
        ip link set eth2 up
        ip addr replace 192.212.25.65/30 dev eth3
        ip link set eth3 up
        ip route replace default via 192.212.28.129
        ip route replace 192.212.8.0/22 via 192.212.14.66
        ip route replace 192.212.12.0/22 via 192.212.14.67
        ip route replace 192.212.0.0/21 via 192.212.14.68
        ip route replace 192.212.24.0/22 via 192.212.25.66
        ip route replace 192.212.16.0/21 via 192.212.22.2
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Wired selesai!"
        ;;

    *psyche*)
        echo "[+] Setup Psyche..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.14.66/29 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.8.1/22 dev eth1
        ip link set eth1 up
        ip route replace default via 192.212.14.65
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Psyche selesai!"
        ;;

    *copland*)
        echo "[+] Setup Copland..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.14.67
    netmask 255.255.255.248
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.14.1
    netmask 255.255.255.192
auto eth2
iface eth2 inet static
    address 192.212.12.1
    netmask 255.255.254.0
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.14.67/29 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.14.1/26 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.12.1/23 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.14.65
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Copland selesai!"
        ;;

    *schumann*)
        echo "[+] Setup Schumann..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.14.68/29 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.4.1/29 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.4.9/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.14.65
        ip route replace 192.212.0.0/22 via 192.212.4.10
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Schumann selesai!"
        ;;

    *accela*)
        echo "[+] Setup Accela..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.4.10
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.0.1
    netmask 255.255.252.0
EOF

        for dev in eth0 eth1; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.4.10/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.0.1/22 dev eth1
        ip link set eth1 up
        ip route replace default via 192.212.4.9
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Accela selesai!"
        ;;

    *navi*)
        echo "[+] Setup Navi..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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

        for dev in eth0 eth1 eth2 eth3; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.25.66/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.24.1/24 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.25.1/26 dev eth2
        ip link set eth2 up
        ip addr replace 192.212.26.1/24 dev eth3
        ip link set eth3 up
        ip route replace default via 192.212.25.65
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Navi selesai!"
        ;;

    *tachibana*)
        echo "[+] Setup Tachibana..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.22.2
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.20.1
    netmask 255.255.254.0
auto eth2
iface eth2 inet static
    address 192.212.18.129
    netmask 255.255.255.252
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.22.2/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.20.1/23 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.18.129/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.22.1
        ip route replace 192.212.16.0/22 via 192.212.18.130
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Tachibana selesai!"
        ;;

    *deus*)
        echo "[+] Setup Deus..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.18.130/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.18.1/25 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.17.65/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.18.129
        ip route replace 192.212.16.0/23 via 192.212.17.66
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Deus selesai!"
        ;;

    *protocol7*)
        echo "[+] Setup Protocol7..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.17.66/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.17.1/26 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.16.137/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.17.65
        ip route replace 192.212.16.0/24 via 192.212.16.138
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Protocol7 selesai!"
        ;;

    *knights*)
        echo "[+] Setup Knights..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.138/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.16.129/29 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.16.97/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.16.137
        ip route replace 192.212.16.0/25 via 192.212.16.98
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Knights selesai!"
        ;;

    *phantoma*)
        echo "[+] Setup Phantoma..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
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
EOF

        for dev in eth0 eth1 eth2; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.98/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.16.65/27 dev eth1
        ip link set eth1 up
        ip addr replace 192.212.16.101/30 dev eth2
        ip link set eth2 up
        ip route replace default via 192.212.16.97
        ip route replace 192.212.16.0/26 via 192.212.16.102
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Phantoma selesai!"
        ;;

    *shibuya*)
        echo "[+] Setup Shibuya..."
        enable_forwarding
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
    address 192.212.16.102
    netmask 255.255.255.252
    post-up sysctl -w net.ipv4.ip_forward=1
auto eth1
iface eth1 inet static
    address 192.212.16.1
    netmask 255.255.255.192
EOF

        for dev in eth0 eth1; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.102/30 dev eth0
        ip link set eth0 up
        ip addr replace 192.212.16.1/26 dev eth1
        ip link set eth1 up
        ip route replace default via 192.212.16.101
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Shibuya selesai!"
        ;;

    *jj*)
        echo "[+] Setup JJ..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.28.2
    netmask 255.255.255.128
    gateway 192.212.28.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.28.2/25 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.28.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi JJ selesai!"
        ;;

    *myumyu*)
        echo "[+] Setup MyuMyu..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.28.3
    netmask 255.255.255.128
    gateway 192.212.28.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.28.3/25 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.28.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi MyuMyu selesai!"
        ;;

    *karl*)
        echo "[+] Setup Karl..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.8.2
    netmask 255.255.252.0
    gateway 192.212.8.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.8.2/22 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.8.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Karl selesai!"
        ;;

    *lin*)
        echo "[+] Setup Lin..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.8.3
    netmask 255.255.252.0
    gateway 192.212.8.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.8.3/22 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.8.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Lin selesai!"
        ;;

    *juri*)
        echo "[+] Setup Juri..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.14.2
    netmask 255.255.255.192
    gateway 192.212.14.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.14.2/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.14.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Juri selesai!"
        ;;

    *masayuki*)
        echo "[+] Setup Masayuki..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.12.2
    netmask 255.255.254.0
    gateway 192.212.12.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.12.2/23 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.12.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Masayuki selesai!"
        ;;

    *akashic*|*akasic*)
        echo "[+] Setup Akashic..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.4.2
    netmask 255.255.255.248
    gateway 192.212.4.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.4.2/29 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.4.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Akashic selesai!"
        ;;

    *omnipresence*)
        echo "[+] Setup Omnipresence..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.0.2
    netmask 255.255.252.0
    gateway 192.212.0.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.0.2/22 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.0.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Omnipresence selesai!"
        ;;

    *denpa*)
        echo "[+] Setup Denpa..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.0.3
    netmask 255.255.252.0
    gateway 192.212.0.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.0.3/22 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.0.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Denpa selesai!"
        ;;

    *alice*)
        echo "[+] Setup Alice..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.24.2
    netmask 255.255.255.0
    gateway 192.212.24.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.24.2/24 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.24.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Alice selesai!"
        ;;

    *reika*)
        echo "[+] Setup Reika..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.24.3
    netmask 255.255.255.0
    gateway 192.212.24.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.24.3/24 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.24.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Reika selesai!"
        ;;

    *taro*)
        echo "[+] Setup Taro..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.25.2
    netmask 255.255.255.192
    gateway 192.212.25.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.25.2/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.25.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Taro selesai!"
        ;;

    *yasuo*)
        echo "[+] Setup Yasuo..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.26.2
    netmask 255.255.255.0
    gateway 192.212.26.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.26.2/24 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.26.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Yasuo selesai!"
        ;;

    *miho*)
        echo "[+] Setup Miho..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.26.3
    netmask 255.255.255.0
    gateway 192.212.26.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.26.3/24 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.26.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Miho selesai!"
        ;;

    *kuma*)
        echo "[+] Setup Kuma..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.26.4
    netmask 255.255.255.0
    gateway 192.212.26.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.26.4/24 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.26.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Kuma selesai!"
        ;;

    *collective*)
        echo "[+] Setup Collective..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.20.2
    netmask 255.255.254.0
    gateway 192.212.20.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.20.2/23 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.20.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Collective selesai!"
        ;;

    *ghost*)
        echo "[+] Setup Ghost..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.20.3
    netmask 255.255.254.0
    gateway 192.212.20.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.20.3/23 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.20.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Ghost selesai!"
        ;;

    *lilith*)
        echo "[+] Setup Lilith..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.18.2
    netmask 255.255.255.128
    gateway 192.212.18.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.18.2/25 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.18.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Lilith selesai!"
        ;;

    *specter*)
        echo "[+] Setup Specter..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.18.3
    netmask 255.255.255.128
    gateway 192.212.18.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.18.3/25 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.18.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Specter selesai!"
        ;;

    *chisa*)
        echo "[+] Setup Chisa..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.17.2
    netmask 255.255.255.192
    gateway 192.212.17.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.17.2/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.17.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Chisa selesai!"
        ;;

    *hodgeson*)
        echo "[+] Setup Hodgeson..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.17.3
    netmask 255.255.255.192
    gateway 192.212.17.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.17.3/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.17.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Hodgeson selesai!"
        ;;

    *eiri*)
        echo "[+] Setup Eiri..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.16.130
    netmask 255.255.255.248
    gateway 192.212.16.129
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.130/29 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.16.129
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Eiri selesai!"
        ;;

    *semi*)
        echo "[+] Setup Semi..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.16.66
    netmask 255.255.255.224
    gateway 192.212.16.65
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.66/27 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.16.65
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Semi selesai!"
        ;;

    *lain*)
        echo "[+] Setup Lain..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.16.2
    netmask 255.255.255.192
    gateway 192.212.16.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.2/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.16.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Lain selesai!"
        ;;

    *mika*)
        echo "[+] Setup Mika..."
        cat << "EOF" > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.16.3
    netmask 255.255.255.192
    gateway 192.212.16.1
EOF

        for dev in eth0; do ip addr flush dev $dev 2>/dev/null || true; done
        ip route flush all 2>/dev/null || true

        ip addr replace 192.212.16.3/26 dev eth0
        ip link set eth0 up
        ip route replace default via 192.212.16.1
        set_resolver
        ensure_persistence
        echo "[OK] Konfigurasi Mika selesai!"
        ;;

    *)
        echo "[!] Node $NODE_NAME tidak dikenali dalam daftar konfigurasi!"
        echo "    Penggunaan: bash /root/init.sh [node_name]"
        exit 1
        ;;
esac

exit 0
