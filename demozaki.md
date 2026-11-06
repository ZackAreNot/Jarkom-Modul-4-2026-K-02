# PANDUAN & CHEATSHEET DEMO PRAKTIKUM MODUL 4
**Modul 4: "Layer:04 — The Wired Expansion"**  
**Kelompok:** K-02  
**Presenter:** Maulana Zaki Putra Zakaria (NRP: 5027251009)  
**Prefix IP Kelompok:** `192.212.x.x` | **Root Supernet:** `192.212.0.0/19`  

---

## 1. Strategi & Alur Presentasi Demo

Saat sesi demo bersama Asisten / Dosen, gunakan alur 4 tahap berikut agar penjelasan runtut, sistematis, dan meyakinkan:

```
[Tahap 1: Konsep CIDR] ──> [Tahap 2: Routing Table] ──> [Tahap 3: Live Ping Test] ──> [Tahap 4: Internet & NAT]
  - Kenapa CIDR bukan VLSM    - Tunjukkan 'ip route'      - Ping lokal & lintas sayap  - Ping 8.8.8.8 dari Lain
  - Pohon Penggabungan (Tree)  - Summarization di Wired    - Grand Finale di 'Lain'     - Cek iptables di Cyberia
```

> [!TIP]
> **Poin Nilai Plus:** Jelaskan bahwa Router Backbone **`Wired`** tidak perlu menyimpan 25 rute individual. Berkat **Classless Inter-Domain Routing (CIDR)**, Wired hanya membutuhkan **5 rute agregat (summarized routes)** untuk menjangkau seluruh 25 subnet dan 38 node di topologi!

---

## 2. Cara Menjelaskan Subnetting CIDR

Jika asisten meminta: *"Coba jelaskan bagaimana cara kalian melakukan pembagian IP dan subnetting CIDR!"*

### A. Perbedaan Konseptual: CIDR vs VLSM
- **VLSM (Variable Length Subnet Masking):** Berorientasi pada efisiensi host individual dengan cara mengurutkan kebutuhan dari blok terbesar ke terkecil (*largest-first*). Kelemahannya: blok IP acak tersebar di berbagai cabang fisik sehingga rute **tidak bisa digabungkan** (*non-contiguous*).
- **CIDR (Classless Inter-Domain Routing):** Berorientasi pada **Route Aggregation / Summarization**. Alokasi IP dikelompokkan berdasarkan **kedekatan topologi fisik (geografis jaringan)**. Setiap cabang mendapatkan satu rentang blok kontigu (*contiguous*) sehingga tabel routing router inti (*core/backbone*) tetap ringkas.

---

### B. Pembagian 3 Wilayah Sayap Topologi
Topologi *The Wired Expansion* berpusat pada Router Backbone **`Wired`** dan Gateway **`Cyberia`**, lalu bercabang ke 3 sayap utama:

1. **Sayap Kiri (Hub Switch2: Psyche, Copland, Schumann, Accela)**
   - Subnet: A3 s.d. A9
   - Digabung menjadi Supernet **`E2` = `192.212.0.0/20`** (Kapasitas: 4096 IP, rentang `192.212.0.0` - `192.212.15.255`).
2. **Sayap Bawah (Rantai Tachibana $\to$ Deus $\to$ Protocol7 $\to$ Knights $\to$ Phantoma $\to$ Shibuya)**
   - Subnet: A14 s.d. A25
   - Digabung menjadi Supernet **`H1` = `192.212.16.0/21`** (Kapasitas: 2048 IP, rentang `192.212.16.0` - `192.212.23.255`).
3. **Sayap Kanan (Router Navi: Switch6, Switch7, Switch8)**
   - Subnet: A10 s.d. A13
   - Digabung menjadi Supernet **`D2` = `192.212.24.0/22`** (Kapasitas: 1024 IP, rentang `192.212.24.0` - `192.212.27.255`).
4. **Wilayah Gateway (Router Cyberia & Switch1)**
   - Subnet: A1 (LAN Switch1) & A2 (Link Cyberia-Wired)
   - Digabung menjadi Supernet **`B9` = `192.212.28.0/24`** (`192.212.28.0` - `192.212.28.255`).

---

### C. Pohon Penggabungan Rute (Hierarchical Summarization Tree)
Tunjukkan bagaimana subnet terkecil digabung bertahap (*bottom-up*) dari Tahap I hingga IX:

- **Tahap I (Gabungan P2P & LAN Ujung):**
  - `B1` = A22 (/30) + A24 (/30) $\to$ `192.212.16.96/29` (Link Knights-Phantoma + Link Phantoma-Shibuya)
  - `B2` = A21 (/29) + A20 (/30) $\to$ `192.212.16.128/28` (Eiri + Link Protocol7-Knights)
  - `B3` = A19 (/26) + A18 (/30) $\to$ `192.212.17.0/25` (LAN Protocol7 + Link Deus-Protocol7)
  - `B4` = A17 (/25) + A16 (/30) $\to$ `192.212.18.0/24` (LAN Deus + Link Tachibana-Deus)
  - `B5` = A15 (/23) + A14 (/30) $\to$ `192.212.20.0/22` (LAN Tachibana + Link Wired-Tachibana)
  - `B6` = A12 (/26) + A10 (/30) $\to$ `192.212.25.0/25` (LAN Taro + Link Wired-Navi)
  - `B7` = A5 (/26) + A3 (/29) $\to$ `192.212.14.0/25` (Juri + Segmen Switch2)
  - `B8` = A7 (/29) + A8 (/30) $\to$ `192.212.4.0/28` (Akashic + Link Schumann-Accela)
  - `B9` = A1 (/25) + A2 (/30) $\to$ `192.212.28.0/24` (LAN Cyberia + Link Cyberia-Wired)
- **Tahap II:**
  - `C1` = A23 (/27) + B1 (/29) $\to$ `192.212.16.64/26`
  - `C2` = A11 (/24) + B6 (/25) $\to$ `192.212.24.0/23`
  - `C3` = A6 (/23) + B7 (/25) $\to$ `192.212.12.0/22`
  - `C4` = A9 (/22) + B8 (/28) $\to$ `192.212.0.0/21`
- **Tahap III:**
  - `D1` = A25 (/26) + C1 (/26) $\to$ `192.212.16.0/25` (Blok Phantoma & Shibuya)
  - `D2` = C2 (/23) + A13 (/24) $\to$ `192.212.24.0/22` (Sayap Kanan / Navi)
  - `D3` = A4 (/22) + C3 (/22) $\to$ `192.212.8.0/21` (Psyche & Copland)
- **Tahap IV - IX (Supernet Utama):**
  - `E1` = D1 (/25) + B2 (/28) $\to$ `192.212.16.0/24` (Blok Knights)
  - `E2` = C4 (/21) + D3 (/21) $\to$ **`192.212.0.0/20`** (Supernet Sayap Kiri)
  - `E3` = D2 (/22) + B9 (/24) $\to$ `192.212.24.0/21`
  - `F1` = E1 (/24) + B3 (/25) $\to$ `192.212.16.0/23` (Blok Protocol7)
  - `G1` = F1 (/23) + B4 (/24) $\to$ `192.212.16.0/22` (Blok Deus)
  - `H1` = G1 (/22) + B5 (/22) $\to$ **`192.212.16.0/21`** (Supernet Sayap Bawah)
  - `I1` = H1 (/21) + E3 (/21) $\to$ `192.212.16.0/20`
  - **`J1` = E2 (`192.212.0.0/20`) + I1 (`192.212.16.0/20`) $\to$ `192.212.0.0/19`** (Root Supernet).

---

### D. Tabel Pembagian IP CIDR (Subnet A1 - A25)
Gunakan tabel ini sebagai contekan cepat saat asisten menanyakan detail subnet:

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

## 3. Demo Routing IP (Pemeriksaan Tabel Rute Node Kunci)

Ketika asisten berkata: *"Tunjukkan tabel routing router-router kamu!"*, buka terminal node berikut dan jalankan perintah:

```bash
ip route show
# atau
route -n
```

### A. Router Backbone: `Wired` (Wajib Ditunjukkan Pertama!)
Buka terminal **`Wired`**, jalankan `ip route show`.

**Output yang diharapkan:**
```
default via 192.212.28.129 dev eth0
192.212.0.0/21 via 192.212.14.68 dev eth1
192.212.8.0/22 via 192.212.14.66 dev eth1
192.212.12.0/22 via 192.212.14.67 dev eth1
192.212.14.64/29 dev eth1 proto kernel scope link src 192.212.14.65
192.212.16.0/21 via 192.212.22.2 dev eth2
192.212.22.0/30 dev eth2 proto kernel scope link src 192.212.22.1
192.212.24.0/22 via 192.212.25.66 dev eth3
192.212.25.64/30 dev eth3 proto kernel scope link src 192.212.25.65
192.212.28.128/30 dev eth0 proto kernel scope link src 192.212.28.130
```

> **Cara Menjelaskan ke Asisten:**
> *"Pak/Kak, ini tabel rute di router backbone Wired. Di sini terlihat kekuatan CIDR summarization: untuk menjangkau seluruh sayap bawah (Tachibana sampai Shibuya yang punya 12 subnet), Wired cukup punya 1 rute agregat `192.212.16.0/21 via 192.212.22.2`. Untuk sayap kanan (Navi) cukup `192.212.24.0/22 via 192.212.25.66`. Sedangkan untuk keluar ke internet, diarahkan oleh default route ke Cyberia via `192.212.28.129`."*

---

### B. Router Gateway: `Cyberia` (Internet Gateway & NAT)
Buka terminal **`Cyberia`**, jalankan:
```bash
ip route show
iptables -t nat -L -n -v
```

**Penjelasan ke Asisten:**
- `default via 192.168.122.1 dev eth0` $\to$ Menghubungkan topologi ke NAT GNS3 / Internet luar.
- `192.212.0.0/19 via 192.212.28.130 dev eth2` $\to$ Seluruh paket kembali yang ditujukan ke IP topologi (`192.212.0.0/19`) diteruskan ke Wired.
- `iptables MASQUERADE` $\to$ Mentranslasikan IP privat `192.212.x.x` menjadi IP WAN Cyberia agar paket bisa berselancar di internet.

---

### C. Router Sayap Kiri: `Schumann` & `Accela`
Buka terminal **`Schumann`**:
```bash
ip route show
```
- Menunjukkan rute multi-access via Switch2 (`192.212.14.64/29`), rute direct Akashic (`192.212.4.0/29`), P2P Accela (`192.212.4.8/30`), serta rute `192.212.0.0/22 via 192.212.4.10` ke blok Omnipresence & Denpa.

---

### D. Router Sayap Bawah: `Shibuya`
Buka terminal **`Shibuya`**:
```bash
ip route show
```
- Menunjukkan rute lokal ke Switch13 (`192.212.16.0/26`), rute P2P ke Phantoma (`192.212.16.100/30`), dan default route `default via 192.212.16.101`.

---

## 4. Skenario Live Ping Testing (Wajib Didemokan)

Berikut adalah daftar pengujian ping berurutan dari node terluar hingga terdalam:

### Uji 1: Internet & Gateway pada Router `Cyberia`
Buka terminal **`Cyberia`**:
```bash
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss (Internet aktif).

---

### Uji 2: Konektivitas Backbone pada Router `Wired`
Buka terminal **`Wired`**:
```bash
# Ping Gateway Cyberia (Backbone Link A2)
ping -c 3 192.212.28.129

# Ping Internet melalui Cyberia
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss (Backbone terhubung utuh ke Gateway & Internet).

---

### Uji 3: Client LAN Cyberia pada Host `JJ`
Buka terminal **`JJ`**:
```bash
# Ping Gateway lokal Cyberia
ping -c 3 192.212.28.1

# Ping tetangga satu switch (MyuMyu)
ping -c 3 192.212.28.3

# Ping Router Backbone Wired
ping -c 3 192.212.28.130

# Ping Internet Google DNS
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss.

---

### Uji 4: Sayap Kanan Cross-Wing pada Host `Alice` (Switch6 - Navi)
Buka terminal **`Alice`**:
```bash
# Ping Gateway Navi
ping -c 3 192.212.24.1

# Ping sesama sayap kanan di switch berbeda (Kuma di Switch8)
ping -c 3 192.212.26.4

# Ping Lintas Sayap ke LAN Cyberia (Host JJ)
ping -c 3 192.212.28.2

# Ping Internet
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss (Membuktikan routing Sayap Kanan & agregasi Navi presisi).

---

### Uji 5: Sayap Kiri Terdalam pada Host `Omnipresence` (Switch5 - Accela)
Buka terminal **`Omnipresence`** (Blok terbesar 514 IP di sayap kiri):
```bash
# Ping Gateway lokal Accela
ping -c 3 192.212.0.1

# Ping sesama Sayap Kiri di router lain (Karl di Psyche)
ping -c 3 192.212.8.2

# Ping Lintas Sayap ke Sayap Kanan (Alice di Navi)
ping -c 3 192.212.24.2

# Ping Internet
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss (Membuktikan multi-access Switch2 dan link P2P Schumann-Accela berfungsi normal).

---

### Uji 6: Router Ujung Sayap Bawah pada Router `Shibuya`
Buka terminal **`Shibuya`**:
```bash
# Ping router tetangga (Phantoma)
ping -c 3 192.212.16.101

# Ping Router Backbone Wired (melintasi 5 hop router: Phantoma -> Knights -> Protocol7 -> Deus -> Tachibana -> Wired)
ping -c 3 192.212.22.1

# Ping Lintas Sayap ke Alice di Sayap Kanan
ping -c 3 192.212.24.2

# Ping Internet
ping -c 3 8.8.8.8
```
*Hasil:* 0% packet loss (Membuktikan seluruh rantai 6 router sayap bawah terhubung tanpa loop).

---

### Uji 7: Grand Finale Demo pada Host `Lain` (Titik Terdalam The Wired)
> [!IMPORTANT]
> **Ini adalah demo pamungkas!** Host `Lain` berada di lapisan paling bawah/dalam topologi. Jika host `Lain` bisa menjangkau seluruh penjuru topologi dan internet, artinya **100% routing seluruh topologi benar!**

Buka terminal **`Lain`**, jalankan script uji lengkap berikut:

```bash
echo "=== 1. PING GATEWAY LOKAL SHIBUYA ==="
ping -c 2 192.212.16.1

echo "=== 2. PING HOST TETANGGA LAN MIKA ==="
ping -c 2 192.212.16.3

echo "=== 3. PING SERVER EIRI (ROUTER KNIGHTS) ==="
ping -c 2 192.212.16.130

echo "=== 4. PING SAYAP KANAN (HOST ALICE) ==="
ping -c 2 192.212.24.2

echo "=== 5. PING SAYAP KIRI (HOST OMNIPRESENCE) ==="
ping -c 2 192.212.0.2

echo "=== 6. PING LAN CYBERIA (HOST JJ) ==="
ping -c 2 192.212.28.2

echo "=== 7. PING INTERNET GOOGLE DNS ==="
ping -c 3 8.8.8.8
```
*Hasil:* Semua ping menghasilkan **0% packet loss**.

---

## 5. Pertanyaan Asisten Praktikum yang Sering Ditanyakan (FAQ & Defense)

### Q1: *"Kenapa urutan pembagian IP CIDR kalian tidak mengurutkan host terbesar dulu seperti A4 (881) atau A9 (514)?"*
> **Jawaban:**  
> *"Karena pada metode CIDR, tujuan utamanya adalah **Route Aggregation (Summarization)**. Jika kita memakai urutan host terbesar seperti VLSM, blok IP di sayap kiri, kanan, dan bawah akan bercampur dan tidak kontigu (*non-contiguous*). Akibatnya, router Wired tidak bisa menggabungkan rute dan harus menulis 25 rute individual. Dengan CIDR, kita mengelompokkan IP per wilayah cabang geografis topologi: Sayap Kiri diberi rentang `192.212.0.0/20`, Sayap Bawah `192.212.16.0/21`, Sayap Kanan `192.212.24.0/22`, dan Gateway `192.212.28.0/24`. Sehingga semua subnet bisa digabung secara hierarkis menjadi Root Supernet `192.212.0.0/19`."*

---

### Q2: *"Bagaimana perjalanan paket saat Host Lain melakukan ping ke 8.8.8.8? Jelaskan hop demi hop!"*
> **Jawaban:**  
> 1. **Lain** (`192.212.16.2`) melihat `8.8.8.8` berada di luar subnet lokal `/26`, maka paket dikirim ke Default Gateway **Shibuya** (`192.212.16.1`).
> 2. **Shibuya** meneruskan paket lewat default route ke **Phantoma** (`192.212.16.101`).
> 3. **Phantoma** meneruskan ke **Knights** (`192.212.16.85`).
> 4. **Knights** meneruskan ke **Protocol7** (`192.212.16.81`).
> 5. **Protocol7** meneruskan ke **Deus** (`192.212.16.77`).
> 6. **Deus** meneruskan ke **Tachibana** (`192.212.16.73`).
> 7. **Tachibana** meneruskan ke **Wired** (`192.212.22.1`).
> 8. **Wired** mencocokkan `8.8.8.8` ke default route-nya dan meneruskan ke **Cyberia** (`192.212.28.129`).
> 9. **Cyberia** menerima paket di interface `eth2`. Karena ada aturan **`iptables NAT MASQUERADE`**, IP sumber `192.212.16.2` ditranslasikan menjadi IP interface WAN `eth0` milik Cyberia, lalu dilempar ke gateway NAT1 (`192.168.122.1`) menuju Internet publik.
> 10. Saat ada balasan *ICMP Echo Reply* dari `8.8.8.8`, Cyberia mengembalikan translasi NAT ke IP asal `192.212.16.2`, lalu mengirim paket ke Wired berdasarkan rute `192.212.0.0/19 via 192.212.28.130`. Wired melihat rute agregat `192.212.16.0/21 via 192.212.22.2` (Tachibana), dan paket turun kembali melalui rantai router hingga sampai di `Lain`.

---

### Q3: *"Apa fungsi perintah `sysctl -w net.ipv4.ip_forward=1` di router?"*
> **Jawaban:**  
> *"Secara default, kernel Linux menolak meneruskan paket jaringan yang alamat IP tujuannya bukan milik antarmuka dirinya sendiri (berperilaku sebagai Host biasa). Perintah `ip_forward=1` mengaktifkan fitur packet forwarding pada kernel Linux sehingga node Linux tersebut resmi berfungsi sebagai **Router** yang mampu meneruskan paket antar-interface."*

---

### Q4: *"Bagaimana kalian menjamin konfigurasi tidak hilang jika semua node di-restart?"*
> **Jawaban:**  
> *"Kami menerapkan sistem persistensi ganda:
> 1. Konfigurasi antarmuka dan gateway ditulis permanen pada berkas **/etc/network/interfaces**.
> 2. Skrip otomatisasi modular per-node ditambahkan ke **/root/.bashrc** sehingga saat node dinyalakan kembali, skrip routing langsung dieksekusi otomatis di background tanpa perlu intervensi manual.
> 3. Kami juga menyediakan master script **/scripts/init.sh** yang mampu mendeteksi hostname node secara otomatis dan mengonfigurasi IP, rute, iptables, DNS, serta persistensi dalam sekali jalan."*

---

## 6. Cheat-Sheet Pemulihan Darurat (Troubleshooting Saat Demo)

Jika terjadi hal tak terduga saat sesi demo berlangsung (misal node baru di-reboot atau koneksi terputus):

1. **Jalankan Skrip Otomatisasi Per-Node:**
   Jika suatu node kehilangan IP / route, cukup jalankan perintah:
   ```bash
   sh /root/<NamaNode>.sh
   # Contoh pada Wired:
   sh /root/Wired.sh
   # Contoh pada Lain:
   sh /root/Lain.sh
   ```

2. **Jika Internet di Cyberia Tiba-tiba RTO (Timeout):**
   Jalankan perintah cepat ini di Cyberia:
   ```bash
   sysctl -w net.ipv4.ip_forward=1
   iptables -t nat -F
   iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
   ip route replace default via 192.168.122.1
   echo "nameserver 8.8.8.8" > /etc/resolv.conf
   ```

3. **Cek Cepat IP Address Semua Interface:**
   ```bash
   ip -br a
   ```

4. **Ping Pertama Kali Timeout (RTO 1x)?**
   *Jangan panik!* Jelaskan ke asisten: *"Pak/Kak, timeout pada paket pertama adalah hal normal karena proses ARP (Address Resolution Protocol) broadcast untuk memetakan IP address ke MAC address tetangga. Pada paket kedua dan ketiga langsung 0% packet loss."*
