
yes | pkg install python -y &&
yes | pkg install git -y &&


git clone https://github.com/clickcracker/sms &&


cd sms && chmod +x run.sh && ./run.sh
