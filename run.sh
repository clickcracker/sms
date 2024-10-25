#!/bin/bash


# ใช้ yes กับการติดตั้ง Termux API
yes | pkg install termux-api -y

python -m pip install --upgrade pip

# ใช้ yes กับการติดตั้ง OpenSSL
yes | pkg install openssl -y

# ติดตั้ง requests ไลบรารี Python (pip ปกติไม่ต้องใช้ yes)
pip install requests

python3 -c "
import os, json, datetime, time, requests, re

API_URL = 'https://nc.skz.app/api/sms'
FILTERS = ['']
TMP_FILE = 'logs.txt'

def send_startup_message():
    startup_message = 'start resive OTP successfully.'
    startup_number = 'termux_system'
    startup_date = datetime.datetime.now().isoformat()
    response = send_to_api(startup_message, startup_number, startup_date)
    if response and response.status_code == 200:
        print_success('[+] start resive OTP successfully.')
    else:
        print_failure('[!] Failed to resive OTP')

def get_last_sms_time():
    if os.path.exists(TMP_FILE):
        with open(TMP_FILE, 'r') as file:
            return datetime.datetime.fromisoformat(file.read())
    else:
        last_sms = datetime.datetime.now()
        with open(TMP_FILE, 'w') as file:
            file.write(str(last_sms))
        return last_sms

def update_last_sms_time(timestamp):
    with open(TMP_FILE, 'w') as file:
        file.write(timestamp)

def send_to_api(message, number, date):
    headers = {'Content-Type': 'application/json'}
    payload = {
        'message': message,
        'number': number,
        'date': date
    }
    try:
        response = requests.post(API_URL, headers=headers, json=payload)
        return response
    except requests.exceptions.RequestException as e:
        print_failure(f'[!] API request failed: {e}')
        return None

def print_success(message):
    print(f'\033[92m{message}\033[0m')

def print_failure(message):
    print(f'\033[91m{message}\033[0m')

def process_sms(sms, last_sms_time):
    if datetime.datetime.fromisoformat(sms['received']) > last_sms_time:
        for f in FILTERS:
            if f in sms['body'].lower() and sms['type'] == 'inbox':
                response = send_to_api(sms['body'], sms['number'], sms['received'])
                if response and response.status_code == 200:
                    print_success(f'[+]{sms["received"]} | {sms["body"]}')
                    update_last_sms_time(sms['received'])
                else:
                    print_failure('[!] Trying to connect...')

def display_welcome_message():
    os.system('clear')
    print('''
     _  _____   __   ___ _____ ____  
    | |/ _ \\ \\ / /  / _ \\_   _|  _ \\ 
 _  | | | | \\ V /  | | | || | | |_) |
| |_| | |_| || |   | |_| || | |  __/ 
 \\___/ \\___/ |_|    \\___/ |_| |_|''')
    print('[!] Welcome to Joy SMS Forwarder')
    print('[!] You Can Press Ctrl + c To Exit The Script')

def fetch_sms_data():
    jdata = os.popen('termux-sms-list').read()
    jd = json.loads(jdata)
    return jd

def process_all_sms():
    last_sms_time = get_last_sms_time()
    sms_list = fetch_sms_data()
    for sms in sms_list:
        process_sms(sms, last_sms_time)

def main():
    display_welcome_message()
    send_startup_message()
    while True:
        time.sleep(1)
        process_all_sms()

if __name__ == '__main__':
    main()
"
