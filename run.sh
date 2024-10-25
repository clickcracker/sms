#!/bin/bash

# เข้าไปในโฟลเดอร์ที่ Clone มา
cd sms

# อัปเดตและอัปเกรดแพ็กเกจ
pkg update && pkg upgrade -y

pkg install termux-api -y

# ติดตั้ง OpenSSL และไลบรารี Python
pkg install openssl -y

# ติดตั้ง requests ไลบรารี
pip install requests

# รัน script ที่สร้างขึ้น
./script
