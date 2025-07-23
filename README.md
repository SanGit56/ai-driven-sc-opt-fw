# Tugas Akhir (TA) - _Final Project_

**Nama Mahasiswa**: Radhiyan Muhammad Hisan  
**NRP**: 5025211166  
**Judul TA**: Pengembangan Kerangka Kerja Optimisasi Kontrak Pintar Berbasis Penggerak Kecerdasan Buatan untuk Hyperledger Fabric  
**Dosen Pembimbing**: Bagus Jati Santoso, S.Kom., Ph.D.  
**Dosen Ko-pembimbing**: Baskoro Adi Pratomo, S.Kom., M.Kom., Ph.D.

---

## Demo Aplikasi

[Video Demo](https://www.youtube.com/watch?v=H19NwgFlCDo)  

---

## Panduan Penyusunan _Virtual Machine_

### Langkah-langkah
1. **Konfigurasi Jaringan Virtual**  
   Buat jaringan virtual pada aplikasi pengelola VM
2. **Siapkan VM**  
   Buat VM dengan spesifikasi sebagai berikut:
   | VM           | vCPU | Memori (GB) | Penyimpanan (GB) |
   |--------------|------|-------------|------------------|
   | LoadBalancer | 2    | 4           | 50               |
   | Worker1      | 1    | 2           | 20               |
   | Worker2      | 2    | 4           | 50               |
   | Worker3      | 4    | 8           | 100              |

---

## Panduan Instalasi & Menjalankan _Software_

### Langkah-langkah  
1. ***Clone Repository***
   ```bash
   git clone https://github.com/Informatics-ITS/ta-SanGit56.git
   ```
2. **Instalasi Dependensi**
   ```bash
   cd ta-SanGit56
   ./kebutuhan.sh
   ```
3. **Konfigurasi Kerangka Kerja**  
   Isi kode API model LLM pada kode program dalam folder src/
4. **Konfigurasi _Orderer Node_**  
   ```bash
   cryptogen generate --config=./organizations/cryptogen/cryptoconfig-orderer.yaml --output="./organizations"
   cryptogen generate --config=./organizations/cryptogen/cryptoconfig-org1.yaml --output="./organizations"
   configtxgen -profile ChannelUsingRaft -outputBlock ./configtx/channel-artifacts/kanal-fabric.block -channelID kanal-fabric
   osnadmin channel join --channelID kanal-fabric --config-block ./configtx/channel-artifacts/kanal-fabric.block -o orderer.example.com:7053 --ca-file "$ORDERER_CA" --clientcert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
   ```
5. **Konfigurasi _Peer Node_**  
   ```bash
   export CORE_PEER_MSPCONFIGPATH=../network/organizations/peerOrganiza tions/org1.example.com/users/Admin@org1.example.com/msp
   peer channel join -b ../network/configtx/channelartifacts/kanal-fabric.block
   ```

---

## Dokumentasi Tambahan

- [Buku TA]()

---

## Ada Pertanyaan?

Hubungi:
- Penulis: Radhiyan Muhammad Hisan (radhiyanrmhhisan@gmail.com)
- Pembimbing Utama: Bagus Jati Santoso, S.Kom., Ph.D. (bagus@its.ac.id)