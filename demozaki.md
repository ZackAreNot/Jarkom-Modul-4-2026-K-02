# Contekan & Materi Demo Modul 4 (Zaki - K02)

**Kelompok:** K-02  
**Prefix IP:** `192.212.x.x` | **Root Supernet:** `192.212.0.0/19`  

---

## 1. Materi Penjelasan Subnetting CIDR

### A. Perbedaan CIDR vs VLSM
- **VLSM:** Membagi IP dari kebutuhan host terbesar ke terkecil (*largest-first*). Kelemahannya: blok IP acak tersebar di berbagai cabang fisik sehingga rute **tidak bisa digabungkan** (*non-contiguous*).
- **CIDR:** Berorientasi pada **Route Aggregation / Summarization**. IP dialokasikan berdasarkan **kedekatan wilayah cabang fisik** secara kontigu (*contiguous*) agar tabel routing di router backbone (`Wired`) tetap ringkas tanpa perlu mendaftar semua subnet satu per satu.

---

### B. Pembagian 3 Wilayah Cabang
Topologi dibagi menjadi 3 sayap utama yang bermuara di Router Backbone **`Wired`** dan Gateway **`Cyberia`**:

1. **Sayap Kiri (Hub Switch2: Psyche, Copland, Schumann, Accela)**
   - Subnet A3 s.d. A9
   - Supernet: **`E2` = `192.212.0.0/20`** (4096 IP: `192.212.0.0` - `192.212.15.255`)
2. **Sayap Bawah (Rantai Router: Tachibana s.d. Shibuya)**
   - Subnet A14 s.d. A25
   - Supernet: **`H1` = `192.212.16.0/21`** (2048 IP: `192.212.16.0` - `192.212.23.255`)
3. **Sayap Kanan (Router Navi: Switch6, Switch7, Switch8)**
   - Subnet A10 s.d. A13
   - Supernet: **`D2` = `192.212.24.0/22`** (1024 IP: `192.212.24.0` - `192.212.27.255`)
4. **Wilayah Gateway (Router Cyberia & Switch1)**
   - Subnet A1 (LAN Switch1) & A2 (Link Cyberia-Wired)
   - Supernet: **`B9` = `192.212.28.0/24`** (`192.212.28.0` - `192.212.28.255`)

---

### C. Tahapan Penggabungan Rute (Supernetting Tree)
- **Tahap I:**
  - `B1` = A22 (/30) + A24 (/30) $\to$ `192.212.16.96/29`
  - `B2` = A21 (/29) + A20 (/30) $\to$ `192.212.16.128/28`
  - `B3` = A19 (/26) + A18 (/30) $\to$ `192.212.17.0/25`
  - `B4` = A17 (/25) + A16 (/30) $\to$ `192.212.18.0/24`
  - `B5` = A15 (/23) + A14 (/30) $\to$ `192.212.20.0/22`
  - `B6` = A12 (/26) + A10 (/30) $\to$ `192.212.25.0/25`
  - `B7` = A5 (/26) + A3 (/29) $\to$ `192.212.14.0/25`
  - `B8` = A7 (/29) + A8 (/30) $\to$ `192.212.4.0/28`
  - `B9` = A1 (/25) + A2 (/30) $\to$ `192.212.28.0/24`
- **Tahap II:**
  - `C1` = A23 (/27) + B1 (/29) $\to$ `192.212.16.64/26`
  - `C2` = A11 (/24) + B6 (/25) $\to$ `192.212.24.0/23`
  - `C3` = A6 (/23) + B7 (/25) $\to$ `192.212.12.0/22`
  - `C4` = A9 (/22) + B8 (/28) $\to$ `192.212.0.0/21`
- **Tahap III:**
  - `D1` = A25 (/26) + C1 (/26) $\to$ `192.212.16.0/25`
  - `D2` = C2 (/23) + A13 (/24) $\to$ `192.212.24.0/22`
  - `D3` = A4 (/22) + C3 (/22) $\to$ `192.212.8.0/21`
- **Tahap IV - IX (Supernet Utama):**
  - `E1` = D1 (/25) + B2 (/28) $\to$ `192.212.16.0/24`
  - `E2` = C4 (/21) + D3 (/21) $\to$ **`192.212.0.0/20`** (Supernet Sayap Kiri)
  - `E3` = D2 (/22) + B9 (/24) $\to$ `192.212.24.0/21`
  - `F1` = E1 (/24) + B3 (/25) $\to$ `192.212.16.0/23`
  - `G1` = F1 (/23) + B4 (/24) $\to$ `192.212.16.0/22`
  - `H1` = G1 (/22) + B5 (/22) $\to$ **`192.212.16.0/21`** (Supernet Sayap Bawah)
  - `I1` = H1 (/21) + E3 (/21) $\to$ `192.212.16.0/20`
  - **`J1` = E2 (`192.212.0.0/20`) + I1 (`192.212.16.0/20`) $\to$ `192.212.0.0/19`** (Root Supernet).

---

### D. Tabel Ringkas Pembagian IP CIDR (Subnet A1 - A25)

| Subnet | Jalur / Titik | Host | Netmask | Network ID | Range Usable IP |
| :---: | :--- | :---: | :---: | :---: | :---: |
| **A1** | Cyberia > Switch1 > JJ, MyuMyu | 126 | `/25` | `192.212.28.0` | `192.212.28.1 - 192.212.28.126` |
| **A2** | Cyberia > Wired | 2 | `/30` | `192.212.28.128` | `192.212.28.129 - 192.212.28.130` |
| **A3** | Wired > Switch2 > Psyche, Copland, Schumann | 4 | `/29` | `192.212.14.64` | `192.212.14.65 - 192.212.14.70` |
| **A4** | Psyche > Switch3 > Karl, Lin | 881 | `/22` | `192.212.8.0` | `192.212.8.1 - 192.212.11.254` |
| **A5** | Copland > Juri (Direct) | 32 | `/26` | `192.212.14.0` | `192.212.14.1 - 192.212.14.62` |
| **A6** | Copland > Switch4 > Masayuki | 301 | `/23` | `192.212.12.0` | `192.212.12.1 - 192.212.13.254` |
| **A7** | Schumann > Akashic (Direct) | 4 | `/29` | `192.212.4.0` | `192.212.4.1 - 192.212.4.6` |
| **A8** | Schumann > Accela | 2 | `/30` | `192.212.4.8` | `192.212.4.9 - 192.212.4.10` |
| **A9** | Accela > Switch5 > Omnipresence, Denpa | 514 | `/22` | `192.212.0.0` | `192.212.0.1 - 192.212.3.254` |
| **A10** | Wired > Navi | 2 | `/30` | `192.212.25.64` | `192.212.25.65 - 192.212.25.66` |
| **A11** | Navi > Switch6 > Alice, Reika | 254 | `/24` | `192.212.24.0` | `192.212.24.1 - 192.212.24.254` |
| **A12** | Navi > Switch7 > Taro | 58 | `/26` | `192.212.25.0` | `192.212.25.1 - 192.212.25.62` |
| **A13** | Navi > Switch8 > Yasuo, Miho, Kuma | 143 | `/24` | `192.212.26.0` | `192.212.26.1 - 192.212.26.254` |
| **A14** | Wired > Tachibana | 2 | `/30` | `192.212.22.0` | `192.212.22.1 - 192.212.22.2` |
| **A15** | Tachibana > Switch9 > Collective, Ghost | 267 | `/23` | `192.212.20.0` | `192.212.20.1 - 192.212.21.254` |
| **A16** | Tachibana > Deus | 2 | `/30` | `192.212.18.128` | `192.212.18.129 - 192.212.18.130` |
| **A17** | Deus > Switch10 > Lilith, Specter | 99 | `/25` | `192.212.18.0` | `192.212.18.1 - 192.212.18.126` |
| **A18** | Deus > Protocol7 | 2 | `/30` | `192.212.17.64` | `192.212.17.65 - 192.212.17.66` |
| **A19** | Protocol7 > Switch11 > Chisa, Hodgeson | 33 | `/26` | `192.212.17.0` | `192.212.17.1 - 192.212.17.62` |
| **A20** | Protocol7 > Knights | 2 | `/30` | `192.212.16.136` | `192.212.16.137 - 192.212.16.138` |
| **A21** | Knights > Eiri (Direct) | 3 | `/29` | `192.212.16.128` | `192.212.16.129 - 192.212.16.134` |
| **A22** | Knights > Phantoma | 2 | `/30` | `192.212.16.96` | `192.212.16.97 - 192.212.16.98` |
| **A23** | Phantoma > Switch12 > Semi | 15 | `/27` | `192.212.16.64` | `192.212.16.65 - 192.212.16.94` |
| **A24** | Phantoma > Shibuya | 2 | `/30` | `192.212.16.100` | `192.212.16.101 - 192.212.16.102` |
| **A25** | Shibuya > Switch13 > Lain, Mika | 62 | `/26` | `192.212.16.0` | `192.212.16.1 - 192.212.16.62` |

---

## 2. Poin Routing IP yang Perlu Ditunjukkan

Perintah untuk mengecek rute di semua node:
```bash
ip route show
```

### A. Router Backbone: `Wired`
Wired hanya punya 5 rute agregat cabang + 1 default gateway ke Cyberia (tidak perlu 25 rute):
- `default via 192.212.28.129` $\to$ ke internet lewat Cyberia
- `192.212.8.0/22 via 192.212.14.66` $\to$ Blok Psyche
- `192.212.12.0/22 via 192.212.14.67` $\to$ Blok Copland
- `192.212.0.0/21 via 192.212.14.68` $\to$ Blok Schumann & Accela
- `192.212.24.0/22 via 192.212.25.66` $\to$ Blok Sayap Kanan (Navi)
- `192.212.16.0/21 via 192.212.22.2` $\to$ Blok Sayap Bawah (Tachibana s.d. Shibuya)

### B. Router Gateway: `Cyberia`
- Rute default WAN internet: `default via 192.168.122.1 dev eth0`
- Rute balik ke seluruh The Wired: `192.212.0.0/19 via 192.212.28.130 dev eth2`
- NAT Masquerade (cek dengan `iptables -t nat -L -n -v`):
  Menyembunyikan seluruh subnet `192.212.x.x` di balik IP WAN Cyberia agar bisa akses internet.

### C. Router Sayap Bawah Ujung: `Shibuya`
- Rute lokal LAN Switch13: `192.212.16.0/26 dev eth1`
- Rute P2P ke Phantoma: `192.212.16.100/30 dev eth0`
- Default route ke atas: `default via 192.212.16.101`

---

## 3. Daftar Perintah Test Ping per Node

Jalankan perintah ping berikut langsung di terminal masing-masing node:

### Node: `Cyberia` (Gateway Internet)
```bash
# Uji koneksi internet keluar
ping -c 3 8.8.8.8
```

### Node: `Wired` (Backbone)
```bash
# Uji koneksi ke Gateway Cyberia
ping -c 3 192.212.28.129

# Uji internet via Cyberia
ping -c 3 8.8.8.8
```

### Node: `JJ` (Client LAN Cyberia - Switch1)
```bash
# Ping Gateway lokal Cyberia
ping -c 3 192.212.28.1

# Ping sesama LAN (MyuMyu)
ping -c 3 192.212.28.3

# Ping Backbone Wired
ping -c 3 192.212.28.130

# Ping Internet
ping -c 3 8.8.8.8
```

### Node: `Alice` (Sayap Kanan - Switch6 / Navi)
```bash
# Ping Gateway lokal Navi
ping -c 3 192.212.24.1

# Ping sesama sayap kanan beda switch (Kuma di Switch8)
ping -c 3 192.212.26.4

# Ping lintas sayap ke LAN Cyberia (Host JJ)
ping -c 3 192.212.28.2

# Ping Internet
ping -c 3 8.8.8.8
```

### Node: `Omnipresence` (Sayap Kiri - Switch5 / Accela)
```bash
# Ping Gateway lokal Accela
ping -c 3 192.212.0.1

# Ping sesama sayap kiri beda router (Karl di Psyche)
ping -c 3 192.212.8.2

# Ping lintas sayap kiri ke kanan (Alice di Navi)
ping -c 3 192.212.24.2

# Ping Internet
ping -c 3 8.8.8.8
```

### Node: `Shibuya` (Router Sayap Bawah Ujung)
```bash
# Ping router tetangga (Phantoma)
ping -c 3 192.212.16.101

# Ping tembus 5 hop ke Backbone Wired
ping -c 3 192.212.22.1

# Ping lintas sayap ke Alice di Navi
ping -c 3 192.212.24.2

# Ping Internet
ping -c 3 8.8.8.8
```

### Node: `Lain` (Host Ujung Terdalam - Grand Final)
Cukup jalankan blok perintah ini di node `Lain`:
```bash
ping -c 2 192.212.16.1    # Gateway lokal Shibuya
ping -c 2 192.212.16.3    # Mika (LAN Switch13)
ping -c 2 192.212.16.130  # Server Eiri (Router Knights)
ping -c 2 192.212.24.2    # Alice (Sayap Kanan - Navi)
ping -c 2 192.212.0.2     # Omnipresence (Sayap Kiri - Accela)
ping -c 2 192.212.28.2    # JJ (LAN Atas - Cyberia)
ping -c 3 8.8.8.8         # Internet Publik Google DNS
```

---

## 4. Poin Jawaban Pertanyaan Teknis (Q&A)

- **Kenapa CIDR tidak diurutkan dari host terbesar?**  
  Karena CIDR butuh pengelompokan IP yang kontigu (*contiguous*) per wilayah cabang (Sayap Kiri `/20`, Sayap Bawah `/21`, Sayap Kanan `/22`, Cyberia `/24`). Jika diurutkan host terbesar seperti VLSM, subnet di cabang berbeda akan tercampur dan tidak bisa digabung (*summarized*) di router Wired.

- **Alur paket dari Lain ke `8.8.8.8`:**  
  `Lain` $\to$ `Shibuya` $\to$ `Phantoma` $\to$ `Knights` $\to$ `Protocol7` $\to$ `Deus` $\to$ `Tachibana` $\to$ `Wired` $\to$ `Cyberia` (kena NAT Masquerade) $\to$ NAT1 GNS3 $\to$ Internet.  
  Paket balik: dari internet masuk `Cyberia` (de-NAT), dilempar ke `Wired` via rute `192.212.0.0/19`, lalu Wired meneruskan ke `Tachibana` via rute agregat `192.212.16.0/21`, dan turun kembali sampai ke `Lain`.

- **Fungsi `sysctl -w net.ipv4.ip_forward=1`:**  
  Mengizinkan kernel Linux meneruskan paket yang bukan ditujukan untuk IP lokal dirinya sendiri (mengubah Linux dari Host biasa menjadi Router).

- **Cara kerja persistensi saat node di-restart:**  
  Konfigurasi interface disimpan di `/etc/network/interfaces`, dan skrip routing otomatis ditambahkan ke baris terakhir `/root/.bashrc`.

---

## 5. Troubleshooting Cepat Saat Demo

- **Jika ada node yang IP atau rutenya belum aktif:**
  ```bash
  sh /root/<NamaNode>.sh
  ```
  *(Contoh: `sh /root/Wired.sh` atau `sh /root/Lain.sh`)*

- **Jika koneksi internet di Cyberia putus / RTO:**
  Jalankan di Cyberia:
  ```bash
  sysctl -w net.ipv4.ip_forward=1
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  ip route replace default via 192.168.122.1
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  ```

- **Jika ping pertama timeout (RTO 1 kali):**  
  Itu adalah proses ARP broadcast untuk mencari MAC address tetangga. Paket kedua dan seterusnya akan langsung reply.
