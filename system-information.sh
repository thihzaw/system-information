#!/bin/bash

#Written By @thihzaw

echo -e "-------------------------------System Information----------------------------"
echo -e "\e[1;32mHostname:\t\t\e[1;31m"`hostname`
echo -e "\e[1;32mUptime:\t\t\t\e[1;33m"`uptime | awk '{print $3,$4}' | sed 's/,//'`
echo -e "\e[1;32mManufacturer:\t\t\e[1;34m"`cat /sys/class/dmi/id/chassis_vendor`
echo -e "\e[1;32mProduct Name:\t\t\e[1;35m"`cat /sys/class/dmi/id/product_name`
echo -e "\e[1;32mVersion:\t\t\e[1;36m"`cat /sys/class/dmi/id/product_version`
echo -e "\e[1;32mSerial Number:\t\t\e[1;37m"`cat /sys/class/dmi/id/product_serial`
echo -e "\e[1;32mMachine Type:\t\t\e[1;31m"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
echo -e "\e[1;32mOperating System:\t\e[1;33m"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
echo -e "\e[1;32mKernel:\t\t\t\e[1;34m"`uname -r`
echo -e "\e[1;32mArchitecture:\t\t\e[1;35m"`arch`
echo -e "\e[1;32mProcessor Name:\t\t\e[1;36m"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
echo -e "\e[1;32mActive User:\t\t\e[1;37m"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
echo -e "\e[1;32mSystem Main IP:\t\t\e[1;31m"`hostname -I`
if [ $HOSTTYPE == "x86_64" ]; then
  echo -e "\e[1;32mArchitecture:\t\t\e[1;33m64 bits"
else
  echo -e "\e[1;32mArchitecture:\t\t\e[1;33m32bits"
fi

echo ""
echo -e "\e[1;32m-------------------------------CPU/Memory Usage------------------------------"
echo -e "\e[1;32mMemory Usage:\t\e[1;31m"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`
echo -e "\e[1;32mSwap Usage:\t\e[1;31m"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`
echo -e "\e[1;32mCPU Usage:\t\e[1;31m"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`
echo ""
echo -e "\e[1;32m-------------------------------Disk Usage >80%-------------------------------"
echo -e "\e[1;35m $(df -Ph | sed s/%//g | awk '{ if($5 > 80) print $0;}')"
echo -e " "

echo -e "\e[1;32m-------------------------------VM or Not -------------------------------"
vserver=$(lscpu | grep Hypervisor | wc -l)
if [ $vserver -gt 0 ]
then
echo -e "\e[1;34m $(hostname) is a VM"
else
echo -e "\e[1;34m $(hostname) is not a VM "
fi

echo -e "\e[1;32m-------------------------------Oracle DB Instances---------------------------"
if id oracle >/dev/null 2>&1; then
/bin/ps -ef|grep pmon
else
echo -e "\e[1;33mOracle user does not exist on $(hostname)"
fi
echo ""
