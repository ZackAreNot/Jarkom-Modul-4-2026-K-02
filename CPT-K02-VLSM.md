# Modul 4 K-02: Cisco Packet Tracer (VLSM), prefix 192.212

Root VLSM: **192.212.0.0/19**. Alokasi terpakai sampai 192.212.16.91. Hasil simulasi: semua node bisa saling ping (0 gagal), total 66 static route.

Device: semua router pakai **Router-PT** (4 port FastEthernet: Fa0/0, Fa1/0, Fa4/0, Fa5/0), switch pakai **2960** atau **Switch-PT**, client pakai **PC-PT**. Kabel: Copper Straight-Through (router ke switch, switch ke PC), Copper Cross-Over (router ke router, router ke PC langsung).

## 1. Tabel VLSM (tab "Pembagian IP - VLSM")

Subnet diurutkan dari blok terbesar, lalu dibagi berurutan mulai 192.212.0.0.

| Subnet | Rute | Jumlah IP | Netmask | Network ID | Netmask | Broadcast | Range IP |
|---|---|---|---|---|---|---|---|
| A1 | Psyche > Switch3 > Karl, Lin | 881 | /22 | 192.212.0.0 | 255.255.252.0 | 192.212.3.255 | 192.212.0.1 - 192.212.3.254 |
| A2 | Accela > Switch5 > Omnipresence, Denpa | 514 | /22 | 192.212.4.0 | 255.255.252.0 | 192.212.7.255 | 192.212.4.1 - 192.212.7.254 |
| A3 | Copland > Switch4 > Masayuki | 301 | /23 | 192.212.8.0 | 255.255.254.0 | 192.212.9.255 | 192.212.8.1 - 192.212.9.254 |
| A4 | Tachibana > Switch9 > Collective, Ghost | 267 | /23 | 192.212.10.0 | 255.255.254.0 | 192.212.11.255 | 192.212.10.1 - 192.212.11.254 |
| A5 | Navi > Switch6 > Alice, Reika | 254 | /24 | 192.212.12.0 | 255.255.255.0 | 192.212.12.255 | 192.212.12.1 - 192.212.12.254 |
| A6 | Navi > Switch8 > Yasuo, Miho, Kuma | 143 | /24 | 192.212.13.0 | 255.255.255.0 | 192.212.13.255 | 192.212.13.1 - 192.212.13.254 |
| A7 | Cyberia > Switch1 > JJ, MyuMyu | 126 | /25 | 192.212.14.0 | 255.255.255.128 | 192.212.14.127 | 192.212.14.1 - 192.212.14.126 |
| A8 | Deus > Switch10 > Lilith, Specter | 99 | /25 | 192.212.14.128 | 255.255.255.128 | 192.212.14.255 | 192.212.14.129 - 192.212.14.254 |
| A9 | Shibuya > Switch13 > Lain, Mika | 62 | /26 | 192.212.15.0 | 255.255.255.192 | 192.212.15.63 | 192.212.15.1 - 192.212.15.62 |
| A10 | Navi > Switch7 > Taro | 58 | /26 | 192.212.15.64 | 255.255.255.192 | 192.212.15.127 | 192.212.15.65 - 192.212.15.126 |
| A11 | Protocol7 > Switch11 > Chisa, Hodgeson | 33 | /26 | 192.212.15.128 | 255.255.255.192 | 192.212.15.191 | 192.212.15.129 - 192.212.15.190 |
| A12 | Copland > Juri | 32 | /26 | 192.212.15.192 | 255.255.255.192 | 192.212.15.255 | 192.212.15.193 - 192.212.15.254 |
| A13 | Phantoma > Switch12 > Semi | 15 | /27 | 192.212.16.0 | 255.255.255.224 | 192.212.16.31 | 192.212.16.1 - 192.212.16.30 |
| A14 | Wired > Switch2 > Psyche, Copland, Schumann | 4 | /29 | 192.212.16.32 | 255.255.255.248 | 192.212.16.39 | 192.212.16.33 - 192.212.16.38 |
| A15 | Schumann > Akashic | 4 | /29 | 192.212.16.40 | 255.255.255.248 | 192.212.16.47 | 192.212.16.41 - 192.212.16.46 |
| A16 | Knights > Eiri | 3 | /29 | 192.212.16.48 | 255.255.255.248 | 192.212.16.55 | 192.212.16.49 - 192.212.16.54 |
| A17 | Cyberia > Wired | 2 | /30 | 192.212.16.56 | 255.255.255.252 | 192.212.16.59 | 192.212.16.57 - 192.212.16.58 |
| A18 | Wired > Navi | 2 | /30 | 192.212.16.60 | 255.255.255.252 | 192.212.16.63 | 192.212.16.61 - 192.212.16.62 |
| A19 | Wired > Tachibana | 2 | /30 | 192.212.16.64 | 255.255.255.252 | 192.212.16.67 | 192.212.16.65 - 192.212.16.66 |
| A20 | Schumann > Accela | 2 | /30 | 192.212.16.68 | 255.255.255.252 | 192.212.16.71 | 192.212.16.69 - 192.212.16.70 |
| A21 | Tachibana > Deus | 2 | /30 | 192.212.16.72 | 255.255.255.252 | 192.212.16.75 | 192.212.16.73 - 192.212.16.74 |
| A22 | Deus > Protocol7 | 2 | /30 | 192.212.16.76 | 255.255.255.252 | 192.212.16.79 | 192.212.16.77 - 192.212.16.78 |
| A23 | Protocol7 > Knights | 2 | /30 | 192.212.16.80 | 255.255.255.252 | 192.212.16.83 | 192.212.16.81 - 192.212.16.82 |
| A24 | Knights > Phantoma | 2 | /30 | 192.212.16.84 | 255.255.255.252 | 192.212.16.87 | 192.212.16.85 - 192.212.16.86 |
| A25 | Phantoma > Shibuya | 2 | /30 | 192.212.16.88 | 255.255.255.252 | 192.212.16.91 | 192.212.16.89 - 192.212.16.90 |

Versi siap paste ke sheet (Subnet, Network ID, Netmask, Broadcast, Range IP):
```
A1	192.212.0.0	255.255.252.0	192.212.3.255	192.212.0.1 - 192.212.3.254
A2	192.212.4.0	255.255.252.0	192.212.7.255	192.212.4.1 - 192.212.7.254
A3	192.212.8.0	255.255.254.0	192.212.9.255	192.212.8.1 - 192.212.9.254
A4	192.212.10.0	255.255.254.0	192.212.11.255	192.212.10.1 - 192.212.11.254
A5	192.212.12.0	255.255.255.0	192.212.12.255	192.212.12.1 - 192.212.12.254
A6	192.212.13.0	255.255.255.0	192.212.13.255	192.212.13.1 - 192.212.13.254
A7	192.212.14.0	255.255.255.128	192.212.14.127	192.212.14.1 - 192.212.14.126
A8	192.212.14.128	255.255.255.128	192.212.14.255	192.212.14.129 - 192.212.14.254
A9	192.212.15.0	255.255.255.192	192.212.15.63	192.212.15.1 - 192.212.15.62
A10	192.212.15.64	255.255.255.192	192.212.15.127	192.212.15.65 - 192.212.15.126
A11	192.212.15.128	255.255.255.192	192.212.15.191	192.212.15.129 - 192.212.15.190
A12	192.212.15.192	255.255.255.192	192.212.15.255	192.212.15.193 - 192.212.15.254
A13	192.212.16.0	255.255.255.224	192.212.16.31	192.212.16.1 - 192.212.16.30
A14	192.212.16.32	255.255.255.248	192.212.16.39	192.212.16.33 - 192.212.16.38
A15	192.212.16.40	255.255.255.248	192.212.16.47	192.212.16.41 - 192.212.16.46
A16	192.212.16.48	255.255.255.248	192.212.16.55	192.212.16.49 - 192.212.16.54
A17	192.212.16.56	255.255.255.252	192.212.16.59	192.212.16.57 - 192.212.16.58
A18	192.212.16.60	255.255.255.252	192.212.16.63	192.212.16.61 - 192.212.16.62
A19	192.212.16.64	255.255.255.252	192.212.16.67	192.212.16.65 - 192.212.16.66
A20	192.212.16.68	255.255.255.252	192.212.16.71	192.212.16.69 - 192.212.16.70
A21	192.212.16.72	255.255.255.252	192.212.16.75	192.212.16.73 - 192.212.16.74
A22	192.212.16.76	255.255.255.252	192.212.16.79	192.212.16.77 - 192.212.16.78
A23	192.212.16.80	255.255.255.252	192.212.16.83	192.212.16.81 - 192.212.16.82
A24	192.212.16.84	255.255.255.252	192.212.16.87	192.212.16.85 - 192.212.16.86
A25	192.212.16.88	255.255.255.252	192.212.16.91	192.212.16.89 - 192.212.16.90
```

## 2. Sambungan kabel tiap router

| Router | Port | Ke | Subnet | IP |
|---|---|---|---|---|
| Cyberia | Fa0/0 | Cloud | - | (tanpa IP) |
| Cyberia | Fa1/0 | Wired | A17 | 192.212.16.57/30 |
| Cyberia | Fa4/0 | Switch1 | A7 | 192.212.14.1/25 |
| Wired | Fa0/0 | Cyberia | A17 | 192.212.16.58/30 |
| Wired | Fa1/0 | Switch2 | A14 | 192.212.16.33/29 |
| Wired | Fa4/0 | Navi | A18 | 192.212.16.61/30 |
| Wired | Fa5/0 | Tachibana | A19 | 192.212.16.65/30 |
| Psyche | Fa0/0 | Switch2 | A14 | 192.212.16.34/29 |
| Psyche | Fa1/0 | Switch3 | A1 | 192.212.0.1/22 |
| Copland | Fa0/0 | Switch2 | A14 | 192.212.16.35/29 |
| Copland | Fa1/0 | Switch4 | A3 | 192.212.8.1/23 |
| Copland | Fa4/0 | Juri | A12 | 192.212.15.193/26 |
| Schumann | Fa0/0 | Switch2 | A14 | 192.212.16.36/29 |
| Schumann | Fa1/0 | Akashic | A15 | 192.212.16.41/29 |
| Schumann | Fa4/0 | Accela | A20 | 192.212.16.69/30 |
| Accela | Fa0/0 | Schumann | A20 | 192.212.16.70/30 |
| Accela | Fa1/0 | Switch5 | A2 | 192.212.4.1/22 |
| Navi | Fa0/0 | Wired | A18 | 192.212.16.62/30 |
| Navi | Fa1/0 | Switch6 | A5 | 192.212.12.1/24 |
| Navi | Fa4/0 | Switch8 | A6 | 192.212.13.1/24 |
| Navi | Fa5/0 | Switch7 | A10 | 192.212.15.65/26 |
| Tachibana | Fa0/0 | Wired | A19 | 192.212.16.66/30 |
| Tachibana | Fa1/0 | Switch9 | A4 | 192.212.10.1/23 |
| Tachibana | Fa4/0 | Deus | A21 | 192.212.16.73/30 |
| Deus | Fa0/0 | Tachibana | A21 | 192.212.16.74/30 |
| Deus | Fa1/0 | Switch10 | A8 | 192.212.14.129/25 |
| Deus | Fa4/0 | Protocol7 | A22 | 192.212.16.77/30 |
| Protocol7 | Fa0/0 | Deus | A22 | 192.212.16.78/30 |
| Protocol7 | Fa1/0 | Switch11 | A11 | 192.212.15.129/26 |
| Protocol7 | Fa4/0 | Knights | A23 | 192.212.16.81/30 |
| Knights | Fa0/0 | Protocol7 | A23 | 192.212.16.82/30 |
| Knights | Fa1/0 | Eiri | A16 | 192.212.16.49/29 |
| Knights | Fa4/0 | Phantoma | A24 | 192.212.16.85/30 |
| Phantoma | Fa0/0 | Knights | A24 | 192.212.16.86/30 |
| Phantoma | Fa1/0 | Switch12 | A13 | 192.212.16.1/27 |
| Phantoma | Fa4/0 | Shibuya | A25 | 192.212.16.89/30 |
| Shibuya | Fa0/0 | Phantoma | A25 | 192.212.16.90/30 |
| Shibuya | Fa1/0 | Switch13 | A9 | 192.212.15.1/26 |

Client yang lewat switch dicolok ke port switch mana saja (misal Fa0/2, Fa0/3, ...).

## 3. Config router (klik router > CLI, paste per router)

### Cyberia
```
enable
configure terminal
hostname Cyberia
interface Fa0/0
 description ke Cloud
 no shutdown
 exit
interface Fa1/0
 description A17 ke Wired
 ip address 192.212.16.57 255.255.255.252
 no shutdown
 exit
interface Fa4/0
 description A7 ke Switch1
 ip address 192.212.14.1 255.255.255.128
 no shutdown
 exit
ip route 192.212.0.0 255.255.224.0 192.212.16.58
end
write memory
```

### Wired
```
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
ip route 0.0.0.0 0.0.0.0 192.212.16.57
ip route 192.212.0.0 255.255.252.0 192.212.16.34
ip route 192.212.8.0 255.255.254.0 192.212.16.35
ip route 192.212.15.192 255.255.255.192 192.212.16.35
ip route 192.212.4.0 255.255.252.0 192.212.16.36
ip route 192.212.16.40 255.255.255.248 192.212.16.36
ip route 192.212.16.68 255.255.255.252 192.212.16.36
ip route 192.212.12.0 255.255.254.0 192.212.16.62
ip route 192.212.15.64 255.255.255.192 192.212.16.62
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

### Psyche
```
enable
configure terminal
hostname Psyche
interface Fa0/0
 description A14 ke Switch2
 ip address 192.212.16.34 255.255.255.248
 no shutdown
 exit
interface Fa1/0
 description A1 ke Switch3
 ip address 192.212.0.1 255.255.252.0
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.33
ip route 192.212.8.0 255.255.254.0 192.212.16.35
ip route 192.212.15.192 255.255.255.192 192.212.16.35
ip route 192.212.4.0 255.255.252.0 192.212.16.36
ip route 192.212.16.40 255.255.255.248 192.212.16.36
ip route 192.212.16.68 255.255.255.252 192.212.16.36
end
write memory
```

### Copland
```
enable
configure terminal
hostname Copland
interface Fa0/0
 description A14 ke Switch2
 ip address 192.212.16.35 255.255.255.248
 no shutdown
 exit
interface Fa1/0
 description A3 ke Switch4
 ip address 192.212.8.1 255.255.254.0
 no shutdown
 exit
interface Fa4/0
 description A12 ke Juri
 ip address 192.212.15.193 255.255.255.192
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.33
ip route 192.212.0.0 255.255.252.0 192.212.16.34
ip route 192.212.4.0 255.255.252.0 192.212.16.36
ip route 192.212.16.40 255.255.255.248 192.212.16.36
ip route 192.212.16.68 255.255.255.252 192.212.16.36
end
write memory
```

### Schumann
```
enable
configure terminal
hostname Schumann
interface Fa0/0
 description A14 ke Switch2
 ip address 192.212.16.36 255.255.255.248
 no shutdown
 exit
interface Fa1/0
 description A15 ke Akashic
 ip address 192.212.16.41 255.255.255.248
 no shutdown
 exit
interface Fa4/0
 description A20 ke Accela
 ip address 192.212.16.69 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.33
ip route 192.212.4.0 255.255.252.0 192.212.16.70
ip route 192.212.0.0 255.255.252.0 192.212.16.34
ip route 192.212.8.0 255.255.254.0 192.212.16.35
ip route 192.212.15.192 255.255.255.192 192.212.16.35
end
write memory
```

### Accela
```
enable
configure terminal
hostname Accela
interface Fa0/0
 description A20 ke Schumann
 ip address 192.212.16.70 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A2 ke Switch5
 ip address 192.212.4.1 255.255.252.0
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.69
end
write memory
```

### Navi
```
enable
configure terminal
hostname Navi
interface Fa0/0
 description A18 ke Wired
 ip address 192.212.16.62 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A5 ke Switch6
 ip address 192.212.12.1 255.255.255.0
 no shutdown
 exit
interface Fa4/0
 description A6 ke Switch8
 ip address 192.212.13.1 255.255.255.0
 no shutdown
 exit
interface Fa5/0
 description A10 ke Switch7
 ip address 192.212.15.65 255.255.255.192
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.61
end
write memory
```

### Tachibana
```
enable
configure terminal
hostname Tachibana
interface Fa0/0
 description A19 ke Wired
 ip address 192.212.16.66 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A4 ke Switch9
 ip address 192.212.10.1 255.255.254.0
 no shutdown
 exit
interface Fa4/0
 description A21 ke Deus
 ip address 192.212.16.73 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.65
ip route 192.212.14.128 255.255.255.128 192.212.16.74
ip route 192.212.15.0 255.255.255.192 192.212.16.74
ip route 192.212.15.128 255.255.255.192 192.212.16.74
ip route 192.212.16.0 255.255.255.224 192.212.16.74
ip route 192.212.16.48 255.255.255.248 192.212.16.74
ip route 192.212.16.76 255.255.255.252 192.212.16.74
ip route 192.212.16.80 255.255.255.248 192.212.16.74
ip route 192.212.16.88 255.255.255.252 192.212.16.74
end
write memory
```

### Deus
```
enable
configure terminal
hostname Deus
interface Fa0/0
 description A21 ke Tachibana
 ip address 192.212.16.74 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A8 ke Switch10
 ip address 192.212.14.129 255.255.255.128
 no shutdown
 exit
interface Fa4/0
 description A22 ke Protocol7
 ip address 192.212.16.77 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.73
ip route 192.212.15.0 255.255.255.192 192.212.16.78
ip route 192.212.15.128 255.255.255.192 192.212.16.78
ip route 192.212.16.0 255.255.255.224 192.212.16.78
ip route 192.212.16.48 255.255.255.248 192.212.16.78
ip route 192.212.16.80 255.255.255.248 192.212.16.78
ip route 192.212.16.88 255.255.255.252 192.212.16.78
end
write memory
```

### Protocol7
```
enable
configure terminal
hostname Protocol7
interface Fa0/0
 description A22 ke Deus
 ip address 192.212.16.78 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A11 ke Switch11
 ip address 192.212.15.129 255.255.255.192
 no shutdown
 exit
interface Fa4/0
 description A23 ke Knights
 ip address 192.212.16.81 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.77
ip route 192.212.15.0 255.255.255.192 192.212.16.82
ip route 192.212.16.0 255.255.255.224 192.212.16.82
ip route 192.212.16.48 255.255.255.248 192.212.16.82
ip route 192.212.16.84 255.255.255.252 192.212.16.82
ip route 192.212.16.88 255.255.255.252 192.212.16.82
end
write memory
```

### Knights
```
enable
configure terminal
hostname Knights
interface Fa0/0
 description A23 ke Protocol7
 ip address 192.212.16.82 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A16 ke Eiri
 ip address 192.212.16.49 255.255.255.248
 no shutdown
 exit
interface Fa4/0
 description A24 ke Phantoma
 ip address 192.212.16.85 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.81
ip route 192.212.15.0 255.255.255.192 192.212.16.86
ip route 192.212.16.0 255.255.255.224 192.212.16.86
ip route 192.212.16.88 255.255.255.252 192.212.16.86
end
write memory
```

### Phantoma
```
enable
configure terminal
hostname Phantoma
interface Fa0/0
 description A24 ke Knights
 ip address 192.212.16.86 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A13 ke Switch12
 ip address 192.212.16.1 255.255.255.224
 no shutdown
 exit
interface Fa4/0
 description A25 ke Shibuya
 ip address 192.212.16.89 255.255.255.252
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.85
ip route 192.212.15.0 255.255.255.192 192.212.16.90
end
write memory
```

### Shibuya
```
enable
configure terminal
hostname Shibuya
interface Fa0/0
 description A25 ke Phantoma
 ip address 192.212.16.90 255.255.255.252
 no shutdown
 exit
interface Fa1/0
 description A9 ke Switch13
 ip address 192.212.15.1 255.255.255.192
 no shutdown
 exit
ip route 0.0.0.0 0.0.0.0 192.212.16.89
end
write memory
```

## 4. IP tiap PC (klik PC > Desktop > IP Configuration > Static)

| PC | Subnet | IP Address | Subnet Mask | Default Gateway |
|---|---|---|---|---|
| Karl | A1 | 192.212.0.2 | 255.255.252.0 | 192.212.0.1 |
| Lin | A1 | 192.212.0.3 | 255.255.252.0 | 192.212.0.1 |
| Omnipresence | A2 | 192.212.4.2 | 255.255.252.0 | 192.212.4.1 |
| Denpa | A2 | 192.212.4.3 | 255.255.252.0 | 192.212.4.1 |
| Masayuki | A3 | 192.212.8.2 | 255.255.254.0 | 192.212.8.1 |
| Collective | A4 | 192.212.10.2 | 255.255.254.0 | 192.212.10.1 |
| Ghost | A4 | 192.212.10.3 | 255.255.254.0 | 192.212.10.1 |
| Alice | A5 | 192.212.12.2 | 255.255.255.0 | 192.212.12.1 |
| Reika | A5 | 192.212.12.3 | 255.255.255.0 | 192.212.12.1 |
| Yasuo | A6 | 192.212.13.2 | 255.255.255.0 | 192.212.13.1 |
| Miho | A6 | 192.212.13.3 | 255.255.255.0 | 192.212.13.1 |
| Kuma | A6 | 192.212.13.4 | 255.255.255.0 | 192.212.13.1 |
| JJ | A7 | 192.212.14.2 | 255.255.255.128 | 192.212.14.1 |
| MyuMyu | A7 | 192.212.14.3 | 255.255.255.128 | 192.212.14.1 |
| Lilith | A8 | 192.212.14.130 | 255.255.255.128 | 192.212.14.129 |
| Specter | A8 | 192.212.14.131 | 255.255.255.128 | 192.212.14.129 |
| Lain | A9 | 192.212.15.2 | 255.255.255.192 | 192.212.15.1 |
| Mika | A9 | 192.212.15.3 | 255.255.255.192 | 192.212.15.1 |
| Taro | A10 | 192.212.15.66 | 255.255.255.192 | 192.212.15.65 |
| Chisa | A11 | 192.212.15.130 | 255.255.255.192 | 192.212.15.129 |
| Hodgeson | A11 | 192.212.15.131 | 255.255.255.192 | 192.212.15.129 |
| Juri | A12 | 192.212.15.194 | 255.255.255.192 | 192.212.15.193 |
| Semi | A13 | 192.212.16.2 | 255.255.255.224 | 192.212.16.1 |
| Akashic | A15 | 192.212.16.42 | 255.255.255.248 | 192.212.16.41 |
| Eiri | A16 | 192.212.16.50 | 255.255.255.248 | 192.212.16.49 |

## 5. Tes ping

Buka PC > Desktop > Command Prompt. Ping pertama kadang timeout (ARP), itu normal, ping lagi.

- Dari **Mika** (ujung Shibuya): `ping 192.212.14.2` (JJ), `ping 192.212.4.2` (Omnipresence), `ping 192.212.0.2` (Karl)
- Dari **Karl** (cabang Psyche): `ping 192.212.15.194` (Juri, cabang Copland), `ping 192.212.4.2` (cabang Schumann), `ping 192.212.15.66` (cabang Navi)
- Dari **JJ** (Cyberia): `ping 192.212.16.50` (Eiri)
- Cek tabel route router: di CLI ketik `show ip route`.
