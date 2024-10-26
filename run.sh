#!/bin/bash

# ใช้ termux-wake-lock เพื่อป้องกันการพักเครื่อง
termux-wake-lock

# ใช้ yes กับการติดตั้ง Termux API
yes | pkg install termux-api -y

# ใช้ yes กับการติดตั้ง OpenSSL
yes | pkg install openssl -y

# ติดตั้ง requests ไลบรารี Python (pip ปกติไม่ต้องใช้ yes)
pip install requests

# ใช้ nohup เพื่อรันโปรแกรม Python ใน Background
nohup python3 your_script.py > sms.log 2>&1 &

# แสดง log แบบสด
tail -f sms.log
