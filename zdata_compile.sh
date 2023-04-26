#!/bin/sh

#FAIL_LOG=/mnt/sdcard0/n20-newBST-ini-4-1part1.txt
#REG_DUMP=/mnt/sdcard0/shmooreg_dump-4-1part1.txt
#TCP_SYN=/mnt/sdcard0/tcp_syn-4-1part1.log

echo "VIN"
grep VIN /mnt/sdcard0/dmesg_log.txt

echo "Clocks"
grep gclk_sd /proc/ambarella/clock 

echo "Kernal Panics"
grep Unable /mnt/sdcard0/dmesg_log.txt*
grep Unable /mnt/sdcard0/dmesg_log.txt* | wc -l

echo "Memtest Fails"
grep failed /mnt/sdcard0/memtester*

echo "Total Memtest Fails"
grep failed /mnt/sdcard0/memtester* | wc -l

echo "Total Dm-Verity Runs"
grep - /mnt/sdcard0/dm0_sha1sum_log* | wc -l

echo "Dm-Verity Corrupt Instances"
grep corrupted /mnt/sdcard0/*dmesg_log.txt* | wc -l
grep corrupted /mnt/sdcard0/*dmesg_log.txt*

#echo "Clocks"
#grep gclk_sd /proc/ambarella/clock

echo "Reboots"
grep BOOT /mnt/sdcard0/memtester* | wc -l
