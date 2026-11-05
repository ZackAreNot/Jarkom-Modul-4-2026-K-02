# PRAKTIKUM JARKOM MODUL 4 KELOMPOK K-02 - 2026

## Anggota Kelompok

| Nama | NRP |
| :--- | :--- |
| Maulana Zaki Putra Zakaria | 5027251009 |
| Naila Anggun Eka Rizqy | 5027251122 |

## Laporan

[LINK SPREADSHEET]
https://docs.google.com/spreadsheets/d/1w6Mh8W8C_vjY8R0xVzYc2j1f4y1E8o/edit?usp=sharing

---

### CPT - VLSM

> [!NOTE]
> **Status Pengerjaan:** *Perancangan Subnetting & Draf Konfigurasi (Progress Parsial)*
> 
> Bagian Cisco Packet Tracer (CPT) dikerjakan oleh rekan kelompok sejauh tahap perancangan teori, subnetting, dan penyusunan berkas konfigurasi teks:
> - **Capaian Pengerjaan:**
>   1. Perhitungan pembagian subnet metode **VLSM (Variable Length Subnet Masking)** dari Subnet A1 s.d. A25 yang diurutkan berdasarkan kebutuhan host terbesar ke terkecil (telah dimasukkan ke spreadsheet tab *Pembagian IP - VLSM*).
>   2. Perancangan pemetaan antarmuka dan port pengkabelan untuk ke-13 router.
>   3. Penyusunan draf skrip Cisco IOS CLI (`ip address`, `no shutdown`, static `ip route`) untuk 13 router pada folder [`routings/cpt/`](./routings/cpt/).
>   4. Perencanaan alokasi static IP address, subnet mask, dan default gateway untuk ke-25 workstation PC client.
> - **Keterbatasan / Kendala:**
>   Karena keterbatasan waktu pengerjaan oleh rekan kelompok, implementasi fisik topologi ke dalam file simulasi Cisco Packet Tracer (`.pkt`) serta **pengujian konektivitas live (ping test) belum sempat diselesaikan secara penuh**.

Pada perancangan VLSM ini digunakan prefix kelompok **`192.212.x.x`** dan Root Supernet **`192.212.0.0/19`**. Seluruh kebutuhan alamat IP diurutkan dari blok terbesar ke terkecil untuk memaksimalkan efisiensi dan mencegah fragmentasi ruang alamat (*address space*).

1. **Spesifikasi Perangkat & Pengkabelan (Rancangan)**
   - **Router:** Menggunakan `Router-PT` dengan 4 interface FastEthernet (`Fa0/0`, `Fa1/0`, `Fa4/0`, `Fa5/0`).
   - **Switch:** Menggunakan switch layer 2 `Switch-2960` atau `Switch-PT`.
   - **Host/Client:** Menggunakan workstation `PC-PT` sebanyak 25 node.
   - **Aturan Pengkabelan:**
     - *Copper Straight-Through:* Menghubungkan Router ke Switch dan Switch ke PC.
     - *Copper Cross-Over:* Menghubungkan Router ke Router (link antar router) dan Router langsung ke PC tanpa switch (Direct link pada Juri, Akashic, dan Eiri).

---

2. **Tabel Pembagian IP (VLSM Subnetting Table)**

Subnetting VLSM dihitung dengan mengurutkan seluruh 25 subnet dari kebutuhan host terbanyak (A1) hingga terkecil (A25), dialokasikan secara berurutan mulai dari Network ID `192.212.0.0` (sesuai tab *Pembagian IP - VLSM* pada spreadsheet):

| Subnet | Jalur / Keterangan | Kebutuhan IP | Netmask | Network ID | Netmask Desimal | Broadcast | Range Usable IP |
| :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **A1** | Psyche > Switch3 > Karl, Lin | 881 | `/22` | `192.212.0.0` | `255.255.252.0` | `192.212.3.255` | `192.212.0.1 - 192.212.3.254` |
| **A2** | Accela > Switch5 > Omnipresence, Denpa | 514 | `/22` | `192.212.4.0` | `255.255.252.0` | `192.212.7.255` | `192.212.4.1 - 192.212.7.254` |
| **A3** | Copland > Switch4 > Masayuki | 301 | `/23` | `192.212.8.0` | `255.255.254.0` | `192.212.9.255` | `192.212.8.1 - 192.212.9.254` |
| **A4** | Tachibana > Switch9 > Collective, Ghost | 267 | `/23` | `192.212.10.0` | `255.255.254.0` | `192.212.11.255` | `192.212.10.1 - 192.212.11.254` |
| **A5** | Navi > Switch6 > Alice, Reika | 254 | `/24` | `192.212.12.0` | `255.255.255.0` | `192.212.12.255` | `192.212.12.1 - 192.212.12.254` |
| **A6** | Navi > Switch8 > Yasuo, Miho, Kuma | 143 | `/24` | `192.212.13.0` | `255.255.255.0` | `192.212.13.255` | `192.212.13.1 - 192.212.13.254` |
| **A7** | Cyberia > Switch1 > JJ, MyuMyu | 126 | `/25` | `192.212.14.0` | `255.255.255.128` | `192.212.14.127` | `192.212.14.1 - 192.212.14.126` |
| **A8** | Deus > Switch10 > Lilith, Specter | 99 | `/25` | `192.212.14.128` | `255.255.255.128` | `192.212.14.255` | `192.212.14.129 - 192.212.14.254` |
| **A9** | Shibuya > Switch13 > Lain, Mika | 62 | `/26` | `192.212.15.0` | `255.255.255.192` | `192.212.15.63` | `192.212.15.1 - 192.212.15.62` |
| **A10** | Navi > Switch7 > Taro | 58 | `/26` | `192.212.15.64` | `255.255.255.192` | `192.212.15.127` | `192.212.15.65 - 192.212.15.126` |
| **A11** | Protocol7 > Switch11 > Chisa, Hodgeson | 33 | `/26` | `192.212.15.128` | `255.255.255.192` | `192.212.15.191` | `192.212.15.129 - 192.212.15.190` |
| **A12** | Copland > Juri (Direct) | 32 | `/26` | `192.212.15.192` | `255.255.255.192` | `192.212.15.255` | `192.212.15.193 - 192.212.15.254` |
| **A13** | Phantoma > Switch12 > Semi | 15 | `/27` | `192.212.16.0` | `255.255.255.224` | `192.212.16.31` | `192.212.16.1 - 192.212.16.30` |
| **A14** | Wired > Switch2 > Psyche, Copland, Schumann | 4 | `/29` | `192.212.16.32` | `255.255.255.248` | `192.212.16.39` | `192.212.16.33 - 192.212.16.38` |
| **A15** | Schumann > Akashic (Direct) | 4 | `/29` | `192.212.16.40` | `255.255.255.248` | `192.212.16.47` | `192.212.16.41 - 192.212.16.46` |
| **A16** | Knights > Eiri (Direct) | 3 | `/29` | `192.212.16.48` | `255.255.255.248` | `192.212.16.55` | `192.212.16.49 - 192.212.16.54` |
| **A17** | Cyberia > Wired | 2 | `/30` | `192.212.16.56` | `255.255.255.252` | `192.212.16.59` | `192.212.16.57 - 192.212.16.58` |
| **A18** | Wired > Navi | 2 | `/30` | `192.212.16.60` | `255.255.255.252` | `192.212.16.63` | `192.212.16.61 - 192.212.16.62` |
| **A19** | Wired > Tachibana | 2 | `/30` | `192.212.16.64` | `255.255.255.252` | `192.212.16.67` | `192.212.16.65 - 192.212.16.66` |
| **A20** | Schumann > Accela | 2 | `/30` | `192.212.16.68` | `255.255.255.252` | `192.212.16.71` | `192.212.16.69 - 192.212.16.70` |
| **A21** | Tachibana > Deus | 2 | `/30` | `192.212.16.72` | `255.255.255.252` | `192.212.16.75` | `192.212.16.73 - 192.212.16.74` |
| **A22** | Deus > Protocol7 | 2 | `/30` | `192.212.16.76` | `255.255.255.252` | `192.212.16.79` | `192.212.16.77 - 192.212.16.78` |
| **A23** | Protocol7 > Knights | 2 | `/30` | `192.212.16.80` | `255.255.255.252` | `192.212.16.83` | `192.212.16.81 - 192.212.16.82` |
| **A24** | Knights > Phantoma | 2 | `/30` | `192.212.16.84` | `255.255.255.252` | `192.212.16.87` | `192.212.16.85 - 192.212.16.86` |
| **A25** | Phantoma > Shibuya | 2 | `/30` | `192.212.16.88` | `255.255.255.252` | `192.212.16.91` | `192.212.16.89 - 192.212.16.90` |

---

3. **Pemetaan Port & Pengkabelan Router**

| Router | Port | Ke (Tujuan) | Subnet | IP Address & Subnet Mask |
| :--- | :---: | :--- | :---: | :--- |
| **Cyberia** | Fa0/0 | Cloud | - | *(Interface WAN / DHCP)* |
| | Fa1/0 | Wired | A17 | `192.212.16.57 255.255.255.252` |
| | Fa4/0 | Switch1 | A7 | `192.212.14.1 255.255.255.128` |
| **Wired** | Fa0/0 | Cyberia | A17 | `192.212.16.58 255.255.255.252` |
| | Fa1/0 | Switch2 | A14 | `192.212.16.33 255.255.255.248` |
| | Fa4/0 | Navi | A18 | `192.212.16.61 255.255.255.252` |
| | Fa5/0 | Tachibana | A19 | `192.212.16.65 255.255.255.252` |
| **Psyche** | Fa0/0 | Switch2 | A14 | `192.212.16.34 255.255.255.248` |
| | Fa1/0 | Switch3 | A1 | `192.212.0.1 255.255.252.0` |
| **Copland** | Fa0/0 | Switch2 | A14 | `192.212.16.35 255.255.255.248` |
| | Fa1/0 | Switch4 | A3 | `192.212.8.1 255.255.254.0` |
| | Fa4/0 | Juri (Direct) | A12 | `192.212.15.193 255.255.255.192` |
| **Schumann** | Fa0/0 | Switch2 | A14 | `192.212.16.36 255.255.255.248` |
| | Fa1/0 | Akashic (Direct) | A15 | `192.212.16.41 255.255.255.248` |
| | Fa4/0 | Accela | A20 | `192.212.16.69 255.255.255.252` |
| **Accela** | Fa0/0 | Schumann | A20 | `192.212.16.70 255.255.255.252` |
| | Fa1/0 | Switch5 | A2 | `192.212.4.1 255.255.252.0` |
| **Navi** | Fa0/0 | Wired | A18 | `192.212.16.62 255.255.255.252` |
| | Fa1/0 | Switch6 | A5 | `192.212.12.1 255.255.255.0` |
| | Fa4/0 | Switch8 | A6 | `192.212.13.1 255.255.255.0` |
| | Fa5/0 | Switch7 | A10 | `192.212.15.65 255.255.255.192` |
| **Tachibana** | Fa0/0 | Wired | A19 | `192.212.16.66 255.255.255.252` |
| | Fa1/0 | Switch9 | A4 | `192.212.10.1 255.255.254.0` |
| | Fa4/0 | Deus | A21 | `192.212.16.73 255.255.255.252` |
| **Deus** | Fa0/0 | Tachibana | A21 | `192.212.16.74 255.255.255.252` |
| | Fa1/0 | Switch10 | A8 | `192.212.14.129 255.255.255.128` |
| | Fa4/0 | Protocol7 | A22 | `192.212.16.77 255.255.255.252` |
| **Protocol7** | Fa0/0 | Deus | A22 | `192.212.16.78 255.255.255.252` |
| | Fa1/0 | Switch11 | A11 | `192.212.15.129 255.255.255.192` |
| | Fa4/0 | Knights | A23 | `192.212.16.81 255.255.255.252` |
| **Knights** | Fa0/0 | Protocol7 | A23 | `192.212.16.82 255.255.255.252` |
| | Fa1/0 | Eiri (Direct) | A16 | `192.212.16.49 255.255.255.248` |
| | Fa4/0 | Phantoma | A24 | `192.212.16.85 255.255.255.252` |
| **Phantoma** | Fa0/0 | Knights | A24 | `192.212.16.86 255.255.255.252` |
| | Fa1/0 | Switch12 | A13 | `192.212.16.1 255.255.255.224` |
| | Fa4/0 | Shibuya | A25 | `192.212.16.89 255.255.255.252` |
| **Shibuya** | Fa0/0 | Phantoma | A25 | `192.212.16.90 255.255.255.252` |
| | Fa1/0 | Switch13 | A9 | `192.212.15.1 255.255.255.192` |

---

4. **Konfigurasi Routing Cisco IOS (CLI)**

Konfigurasi antarmuka dan static route lengkap untuk seluruh 13 router disimpan secara modular pada folder [`routings/cpt/`](routings/cpt/):
- **Core Routers:** [`routings/cpt/core-route.txt`](routings/cpt/core-route.txt) (`Cyberia`, `Wired`)
- **Sayap Kiri:** [`routings/cpt/left-route.txt`](routings/cpt/left-route.txt) (`Psyche`, `Copland`, `Schumann`, `Accela`)
- **Sayap Kanan:** [`routings/cpt/right-route.txt`](routings/cpt/right-route.txt) (`Navi`)
- **Sayap Bawah:** [`routings/cpt/bottom-route.txt`](routings/cpt/bottom-route.txt) (`Tachibana`, `Deus`, `Protocol7`, `Knights`, `Phantoma`, `Shibuya`)

Contoh cuplikan konfigurasi Cisco IOS CLI pada Router Backbone **`Wired`**:

```cisco
enable
configure terminal
hostname Wired

interface Fa0/0
 description A17 ke Cyberia
 ip address 192.212.16.58 255.255.255.252
 no shutdown
 exit

interface Fa1/0
 description A14 ke Switch2
 ip address 192.212.16.33 255.255.255.248
 no shutdown
 exit

interface Fa4/0
 description A18 ke Navi
 ip address 192.212.16.61 255.255.255.252
 no shutdown
 exit

interface Fa5/0
 description A19 ke Tachibana
 ip address 192.212.16.65 255.255.255.252
 no shutdown
 exit

# Default route ke Gateway Cyberia
ip route 0.0.0.0 0.0.0.0 192.212.16.57

# Static routes ke Sayap Kiri (via Switch2)
ip route 192.212.0.0 255.255.252.0 192.212.16.34
ip route 192.212.8.0 255.255.254.0 192.212.16.35
ip route 192.212.15.192 255.255.255.192 192.212.16.35
ip route 192.212.4.0 255.255.252.0 192.212.16.36
ip route 192.212.16.40 255.255.255.248 192.212.16.36
ip route 192.212.16.68 255.255.255.252 192.212.16.36

# Static routes ke Sayap Kanan (via Navi)
ip route 192.212.12.0 255.255.254.0 192.212.16.62
ip route 192.212.15.64 255.255.255.192 192.212.16.62

# Static routes ke Sayap Bawah (via Tachibana)
ip route 192.212.10.0 255.255.254.0 192.212.16.66
ip route 192.212.14.128 255.255.255.128 192.212.16.66
ip route 192.212.15.0 255.255.255.192 192.212.16.66
ip route 192.212.15.128 255.255.255.192 192.212.16.66
ip route 192.212.16.0 255.255.255.224 192.212.16.66
ip route 192.212.16.48 255.255.255.248 192.212.16.66
ip route 192.212.16.72 255.255.255.248 192.212.16.66
ip route 192.212.16.80 255.255.255.248 192.212.16.66
ip route 192.212.16.88 255.255.255.252 192.212.16.66
end
write memory
```

---

5. **Konfigurasi Static IP PC Client**

Pengaturan IP pada seluruh 25 workstation (`PC-PT`) di CPT melalui menu **Desktop > IP Configuration**:

| PC Client | Subnet | IP Address | Subnet Mask | Default Gateway |
| :--- | :---: | :---: | :---: | :---: |
| **Karl** | A1 | `192.212.0.2` | `255.255.252.0` | `192.212.0.1` |
| **Lin** | A1 | `192.212.0.3` | `255.255.252.0` | `192.212.0.1` |
| **Omnipresence** | A2 | `192.212.4.2` | `255.255.252.0` | `192.212.4.1` |
| **Denpa** | A2 | `192.212.4.3` | `255.255.252.0` | `192.212.4.1` |
| **Masayuki** | A3 | `192.212.8.2` | `255.255.254.0` | `192.212.8.1` |
| **Collective** | A4 | `192.212.10.2` | `255.255.254.0` | `192.212.10.1` |
| **Ghost** | A4 | `192.212.10.3` | `255.255.254.0` | `192.212.10.1` |
| **Alice** | A5 | `192.212.12.2` | `255.255.255.0` | `192.212.12.1` |
| **Reika** | A5 | `192.212.12.3` | `255.255.255.0` | `192.212.12.1` |
| **Yasuo** | A6 | `192.212.13.2` | `255.255.255.0` | `192.212.13.1` |
| **Miho** | A6 | `192.212.13.3` | `255.255.255.0` | `192.212.13.1` |
| **Kuma** | A6 | `192.212.13.4` | `255.255.255.0` | `192.212.13.1` |
| **JJ** | A7 | `192.212.14.2` | `255.255.255.128` | `192.212.14.1` |
| **MyuMyu** | A7 | `192.212.14.3` | `255.255.255.128` | `192.212.14.1` |
| **Lilith** | A8 | `192.212.14.130` | `255.255.255.128` | `192.212.14.129` |
| **Specter** | A8 | `192.212.14.131` | `255.255.255.128` | `192.212.14.129` |
| **Lain** | A9 | `192.212.15.2` | `255.255.255.192` | `192.212.15.1` |
| **Mika** | A9 | `192.212.15.3` | `255.255.255.192` | `192.212.15.1` |
| **Taro** | A10 | `192.212.15.66` | `255.255.255.192` | `192.212.15.65` |
| **Chisa** | A11 | `192.212.15.130` | `255.255.255.192` | `192.212.15.129` |
| **Hodgeson** | A11 | `192.212.15.131` | `255.255.255.192` | `192.212.15.129` |
| **Juri** | A12 | `192.212.15.194` | `255.255.255.192` | `192.212.15.193` |
| **Semi** | A13 | `192.212.16.2` | `255.255.255.224` | `192.212.16.1` |
| **Akashic** | A15 | `192.212.16.42` | `255.255.255.248` | `192.212.16.41` |
| **Eiri** | A16 | `192.212.16.50` | `255.255.255.248` | `192.212.16.49` |

---

6. **Rancangan Prosedur Pengujian (Testing Plan)**

Berikut merupakan skenario pengujian konektivitas yang telah dirancang untuk memverifikasi jalur routing apabila simulasi di Cisco Packet Tracer dijalankan:
- **Dari Mika (Ujung Sayap Bawah - Shibuya):**
  - `ping 192.212.14.2` (JJ - Sayap Cyberia)
  - `ping 192.212.4.2` (Omnipresence - Sayap Kiri Accela)
  - `ping 192.212.0.2` (Karl - Sayap Kiri Psyche)
- **Dari Karl (Sayap Kiri - Psyche):**
  - `ping 192.212.15.194` (Juri - Direct Copland)
  - `ping 192.212.4.2` (Omnipresence - Cabang Schumann/Accela)
  - `ping 192.212.15.66` (Taro - Cabang Navi)
- **Dari JJ (Sayap Atas - Cyberia):**
  - `ping 192.212.16.50` (Eiri - Sayap Bawah Knights)
- **Verifikasi Tabel Rute Router:**
  - Perintah `show ip route` pada CLI masing-masing router untuk memverifikasi entri tabel routing statis aktif.

---

### GNS3 - CIDR

Pada topologi GNS3 diterapkan metode **CIDR (Classless Inter-Domain Routing)** dengan prefix kelompok **`192.212.x.x`** dan Root Supernet **`192.212.0.0/19`**. Fokus utama CIDR adalah efisiensi alokasi alamat dan agregasi rute (*route summarization*).

![Topologi GNS3 + Pembagian Subnet](assets/Topologi_GNS3_Pembagian_Subnet.png)

1. **Topologi Jaringan GNS3**

   Jaringan "The Wired Expansion" dibagi menjadi 3 wilayah percabangan utama yang berpusat pada Router Backbone **`Wired`** dan Router Gateway **`Cyberia`**:
   - **Sayap Kiri:** Hub Switch2 (`Psyche`, `Copland`, `Schumann`, `Accela`).
   - **Sayap Kanan:** Router `Navi` (`Switch6`, `Switch7`, `Switch8`).
   - **Sayap Bawah:** Rantai Router `Tachibana` $\to$ `Deus` $\to$ `Protocol7` $\to$ `Knights` $\to$ `Phantoma` $\to$ `Shibuya`.

---

2. **Tabel Pembagian IP (CIDR Subnetting Table)**

Total kebutuhan IP jaringan adalah **2814 IP** (termasuk host dan interface router) yang dialokasikan ke dalam **25 Subnet** tanpa adanya overlap:

| Subnet | Jalur / Rute | Kebutuhan IP | Netmask | Network ID | Range Usable IP | Broadcast |
| :---: | :--- | :---: | :---: | :---: | :---: | :---: |
| **A1** | Cyberia > Switch1 > JJ, MyuMyu | 126 | `/25` | `192.212.28.0` | `192.212.28.1 - 192.212.28.126` | `192.212.28.127` |
| **A2** | Cyberia > Wired | 2 | `/30` | `192.212.28.128` | `192.212.28.129 - 192.212.28.130` | `192.212.28.131` |
| **A3** | Wired > Switch2 > Psyche, Copland, Schumann | 4 | `/29` | `192.212.14.64` | `192.212.14.65 - 192.212.14.70` | `192.212.14.71` |
| **A4** | Psyche > Switch3 > Karl, Lin | 881 | `/22` | `192.212.8.0` | `192.212.8.1 - 192.212.11.254` | `192.212.11.255` |
| **A5** | Copland > Juri (Direct) | 32 | `/26` | `192.212.14.0` | `192.212.14.1 - 192.212.14.62` | `192.212.14.63` |
| **A6** | Copland > Switch4 > Masayuki | 301 | `/23` | `192.212.12.0` | `192.212.12.1 - 192.212.13.254` | `192.212.13.255` |
| **A7** | Schumann > Akashic (Direct) | 4 | `/29` | `192.212.4.0` | `192.212.4.1 - 192.212.4.6` | `192.212.4.7` |
| **A8** | Schumann > Accela | 2 | `/30` | `192.212.4.8` | `192.212.4.9 - 192.212.4.10` | `192.212.4.11` |
| **A9** | Accela > Switch5 > Omnipresence, Denpa | 514 | `/22` | `192.212.0.0` | `192.212.0.1 - 192.212.3.254` | `192.212.3.255` |
| **A10** | Wired > Navi | 2 | `/30` | `192.212.25.64` | `192.212.25.65 - 192.212.25.66` | `192.212.25.67` |
| **A11** | Navi > Switch6 > Alice, Reika | 254 | `/24` | `192.212.24.0` | `192.212.24.1 - 192.212.24.254` | `192.212.24.255` |
| **A12** | Navi > Switch7 > Taro | 58 | `/26` | `192.212.25.0` | `192.212.25.1 - 192.212.25.62` | `192.212.25.63` |
| **A13** | Navi > Switch8 > Yasuo, Miho, Kuma | 143 | `/24` | `192.212.26.0` | `192.212.26.1 - 192.212.26.254` | `192.212.26.255` |
| **A14** | Wired > Tachibana | 2 | `/30` | `192.212.22.0` | `192.212.22.1 - 192.212.22.2` | `192.212.22.3` |
| **A15** | Tachibana > Switch9 > Collective, Ghost | 267 | `/23` | `192.212.20.0` | `192.212.20.1 - 192.212.21.254` | `192.212.21.255` |
| **A16** | Tachibana > Deus | 2 | `/30` | `192.212.18.128` | `192.212.18.129 - 192.212.18.130` | `192.212.18.131` |
| **A17** | Deus > Switch10 > Lilith, Specter | 99 | `/25` | `192.212.18.0` | `192.212.18.1 - 192.212.18.126` | `192.212.18.127` |
| **A18** | Deus > Protocol7 | 2 | `/30` | `192.212.17.64` | `192.212.17.65 - 192.212.17.66` | `192.212.17.67` |
| **A19** | Protocol7 > Switch11 > Chisa, Hodgeson | 33 | `/26` | `192.212.17.0` | `192.212.17.1 - 192.212.17.62` | `192.212.17.63` |
| **A20** | Protocol7 > Knights | 2 | `/30` | `192.212.16.136` | `192.212.16.137 - 192.212.16.138` | `192.212.16.139` |
| **A21** | Knights > Eiri (Direct) | 3 | `/29` | `192.212.16.128` | `192.212.16.129 - 192.212.16.134` | `192.212.16.135` |
| **A22** | Knights > Phantoma | 2 | `/30` | `192.212.16.96` | `192.212.16.97 - 192.212.16.98` | `192.212.16.99` |
| **A23** | Phantoma > Switch12 > Semi | 15 | `/27` | `192.212.16.64` | `192.212.16.65 - 192.212.16.94` | `192.212.16.95` |
| **A24** | Phantoma > Shibuya | 2 | `/30` | `192.212.16.100` | `192.212.16.101 - 192.212.16.102` | `192.212.16.103` |
| **A25** | Shibuya > Switch13 > Lain, Mika | 62 | `/26` | `192.212.16.0` | `192.212.16.1 - 192.212.16.62` | `192.212.16.63` |

---

3. **Perhitungan Penggabungan Rute (CIDR Supernetting)**

Penggabungan rute dilakukan secara hierarkis (*bottom-up*) dari subnet terkecil hingga mencapai Root Supernet:

![Topologi GNS3 + Penggabungan CIDR](assets/Topologi_GNS3_Penggabungan_CIDR.png)

* **Tahap I**:
  - `B1` = A22 + A24 $\to$ `/29` (Link Knights-Phantoma + Phantoma-Shibuya)
  - `B2` = A21 + A20 $\to$ `/28` (Eiri + Link Protocol7-Knights)
  - `B3` = A19 + A18 $\to$ `/25` (LAN Protocol7 + Link Deus-Protocol7)
  - `B4` = A17 + A16 $\to$ `/24` (LAN Deus + Link Tachibana-Deus)
  - `B5` = A15 + A14 $\to$ `/22` (LAN Tachibana + Link Wired-Tachibana)
  - `B6` = A12 + A10 $\to$ `/25` (LAN Taro + Link Wired-Navi)
  - `B7` = A5 + A3 $\to$ `/25` (Juri + Segmen Switch2)
  - `B8` = A7 + A8 $\to$ `/28` (Akashic + Link Schumann-Accela)
  - `B9` = A1 + A2 $\to$ `/24` (LAN Cyberia + Link Cyberia-Wired)
* **Tahap II**:
  - `C1` = A23 + B1 $\to$ `/26` (Semi + B1)
  - `C2` = A11 + B6 $\to$ `/23` (Alice, Reika + B6)
  - `C3` = A6 + B7 $\to$ `/22` (Blok Copland)
  - `C4` = A9 + B8 $\to$ `/21` (Blok Schumann & Accela)
* **Tahap III**:
  - `D1` = A25 + C1 $\to$ `/25` (Blok Phantoma & Shibuya)
  - `D2` = C2 + A13 $\to$ `/22` (Blok Kanan / Navi: `192.212.24.0/22`)
  - `D3` = A4 + C3 $\to$ `/21` (Psyche + Copland)
* **Tahap IV - IX (Supernet Utama)**:
  - `E1` = D1 + B2 $\to$ `/24` (Blok Knights)
  - `E2` = C4 + D3 $\to$ `/20` (Blok Kiri Switch2: `192.212.0.0/20`)
  - `E3` = D2 + B9 $\to$ `/21` (Navi + Cyberia)
  - `F1` = E1 + B3 $\to$ `/23` (Blok Protocol7)
  - `G1` = F1 + B4 $\to$ `/22` (Blok Deus)
  - `H1` = G1 + B5 $\to$ `/21` (Blok Bawah Tachibana: `192.212.16.0/21`)
  - `I1` = H1 + E3 $\to$ `/20`
  - **`J1` (Root Supernet)** = E2 + I1 $\to$ **`192.212.0.0/19`** (Mencakup seluruh jaringan The Wired).

---

4. **Konfigurasi & Routing Efisien**

Setiap node diatur dengan skrip modular di [`routings/gns3/`](./routings/gns3/) dan persistensi sistem dijamin melalui [`scripts/init.sh`](./scripts/init.sh).

Contoh tabel routing ringkas pada Router Backbone **`Wired`**:

```bash
# Default ke internet melalui Cyberia
ip route add default via 192.212.28.129

# Rute agregat ke masing-masing cabang
ip route add 192.212.8.0/22 via 192.212.14.66   # Blok Psyche
ip route add 192.212.12.0/22 via 192.212.14.67  # Blok Copland
ip route add 192.212.0.0/21 via 192.212.14.68   # Blok Schumann
ip route add 192.212.24.0/22 via 192.212.25.66  # Blok Kanan (Navi)
ip route add 192.212.16.0/21 via 192.212.22.2   # Blok Bawah (Tachibana)
```

---

5. **Pengujian Konektivitas (Testing)**

* **Uji Koneksi Internet Gateway pada Router Cyberia**:
  Router Cyberia terhubung ke NAT GNS3 (`NAT1`), menerima IP WAN, dan berhasil melakukan ping keluar ke internet (`8.8.8.8`):

  ![Ping Cyberia ke Internet](assets/Cyberia_Ping_Internet.png)
  *(Hasil: 3 packets transmitted, 3 received, 0% packet loss, RTT ~21ms)*

* **Uji Konektivitas Backbone pada Router Wired**:
  Router Wired berhasil terhubung ke Router Cyberia (`192.212.28.129`) dan meneruskan koneksi keluar ke internet (`8.8.8.8`):

  ![Ping Wired ke Cyberia & Internet](assets/Wired_Ping_Internet.png)
  *(Hasil: Ping ke Cyberia RTT ~0.3ms, Ping ke Internet RTT ~21ms, 0% packet loss)*

* **Uji Konektivitas Client LAN Cyberia (Host JJ)**:
  Client JJ (`192.212.28.2`) berhasil melakukan komunikasi lokal ke Gateway Cyberia (`192.212.28.1`), ke sesama host LAN MyuMyu (`192.212.28.3`), menembus ke Router Backbone Wired (`192.212.28.130`), serta akses penuh ke Internet (`8.8.8.8`):

  ![Ping JJ ke LAN dan Backbone](assets/JJ_Ping_LAN_and_Backbone.png)
  ![Ping JJ ke Internet](assets/JJ_Ping_Internet.png)
  *(Hasil: 0% packet loss ke seluruh target pengujian)*

* **Uji Konektivitas Router Sayap Kanan (Navi)**:
  Router Navi berhasil terhubung ke Router Backbone Wired (`192.212.25.65`), menembus ke Gateway Cyberia (`192.212.28.1`), menembus ke Client LAN Cyberia JJ (`192.212.28.2`), serta koneksi keluar ke Internet (`8.8.8.8`):

  ![Ping Navi ke Seluruh Titik](assets/Navi_Ping_All.png)
  *(Hasil: 0% packet loss ke seluruh router, host cross-wing, dan internet)*

* **Uji Konektivitas Host Sayap Kanan Lintas Sayap (Cross-Wing Ping - Host Alice)**:
  Host Alice (`192.212.24.2`) di bawah Switch6 berhasil melakukan ping ke Gateway Navi (`192.212.24.1`), ke sesama host di sayap kanan Kuma (`192.212.26.4`), melintasi seluruh backbone ke Client JJ (`192.212.28.2`) di Sayap Cyberia, serta tembus ke Internet (`8.8.8.8`):

  ![Ping Alice Lintas Sayap & Internet](assets/Alice_Ping_CrossWing.png)
  *(Hasil: 0% packet loss, membuktikan subnetting CIDR dan route summarization Sayap Kanan berjalan presisi)*

* **Uji Konektivitas Router Sayap Kiri Terdalam (Router Accela)**:
  Router Accela (`192.212.4.10`) berhasil melakukan ping ke Router Schumann (`192.212.4.9`), ke Router Backbone Wired (`192.212.14.65`) melalui Switch2, melintasi seluruh jaringan ke Host Alice (`192.212.24.2`) di Sayap Kanan, serta akses ke Internet (`8.8.8.8`):

  ![Ping Accela ke Seluruh Jaringan & Internet](assets/Accela_Ping_All.png)
  *(Hasil: 0% packet loss, membuktikan rute multi-access Switch2 dan agregasi Sayap Kiri terhubung utuh)*

* **Uji Konektivitas Host Sayap Kiri Terdalam (Host Omnipresence)**:
  Host Omnipresence (`192.212.0.2`, 510 host di bawah Switch5) berhasil melakukan ping ke Gateway Accela (`192.212.0.1`), ke sesama host Sayap Kiri Karl (`192.212.8.2`), melintasi seluruh jaringan ke Host Alice (`192.212.24.2`) di Sayap Kanan, ke Host JJ (`192.212.28.2`) di LAN Cyberia, serta tembus ke Internet (`8.8.8.8`):

  ![Ping Omnipresence ke Seluruh Jaringan & Internet](assets/Omnipresence_Ping_CrossWing.png)
  *(Hasil: 0% packet loss ke seluruh 5 target, membuktikan integritas routing Sayap Kiri sempurna)*

* **Uji Konektivitas Router Sayap Bawah Ujung (Router Shibuya)**:
  Router Shibuya (`192.212.16.102`) sebagai router terdalam di sayap bawah berhasil melakukan ping ke Router Phantoma (`192.212.16.101`), melintasi rantai 5 router ke Router Backbone Wired (`192.212.22.1`), melintasi seluruh jaringan ke Host Alice (`192.212.24.2`) di Sayap Kanan, ke Host Omnipresence (`192.212.0.2`) di Sayap Kiri, serta akses ke Internet (`8.8.8.8`):

  ![Ping Shibuya ke Seluruh Titik & Internet](assets/Shibuya_Ping_All.png)
  *(Hasil: 0% packet loss, membuktikan seluruh 13 router terhubung sempurna tanpa loop)*

* **Uji Pamungkas Konektivitas Menyeluruh (Host Lain - Lapisan Terdalam The Wired)**:
  Host Lain (`192.212.16.2`) yang berada di lapisan paling dalam The Wired diuji melakukan koneksi ke setiap penjuru topologi. Hasil pengujian menunjukkan **0% packet loss (sukses penuh)** ke seluruh target:
  1. Gateway lokal Shibuya (`192.212.16.1`)
  2. Host tetangga Mika (`192.212.16.3`)
  3. Server Eiri (`192.212.16.130`) pada Router Knights
  4. Host Alice (`192.212.24.2`) di Sayap Kanan
  5. Host Omnipresence (`192.212.0.2`) di Sayap Kiri
  6. Host JJ (`192.212.28.2`) di LAN Cyberia
  7. Internet Publik (`8.8.8.8`) melalui NAT Cyberia

  ![Ping Lain ke Jaringan Internal](assets/Lain_Ping_Internal.png)
  ![Ping Lain Lintas Sayap & Internet](assets/Lain_Ping_CrossWing_and_Internet.png)

---
