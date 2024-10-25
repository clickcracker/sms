#!/bin/bash

# อัปเดตและอัปเกรดแพ็กเกจ
pkg update && pkg upgrade -y

# ติดตั้ง Python และแพ็กเกจที่จำเป็น
pkg install python -y
pkg install git -y
pkg install termux-api -y

# Clone repository
git clone https://github.com/clickcracker/sms

# เข้าไปในโฟลเดอร์ที่ Clone มา
cd sms

# ติดตั้ง OpenSSL และไลบรารี Python
pkg install openssl -y

# ติดตั้ง requests ไลบรารี
pip install requests

# รัน script ที่สร้างขึ้น
./script
