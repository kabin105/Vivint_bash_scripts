#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'       # Yellow
NOCOL='\033[0m' # No Color

IP_COMMON="10.65.4."

IP_last_digits=(
  '83' '82' '81' '80' '77'
  '84' '76' '78' '79' '54' 
  '57' '64' '56' '60' '59' 
  '61' '62' '63' '55' '58' 
  '52'
)

CAMERA_LABEL=(
  '12' '13' '14' '17' '20'
  '21' '22' '23' '24' '25'
  '26' '27' '28' '29' '30'
  '31' '32' '33' '34' '35'
  '36'
)

for ((j = 1; j <= "${#IP_last_digits[@]}"; j++)); do
  IP=$IP_COMMON"${IP_last_digits[i-1]}" # Complete IP for each camera
  echo "Camera ${CAMERA_LABEL[j-1]} ($IP)"
  if [ ${IP_last_digits[j-1]} == 60 ]; then
    continue
  fi
  
  if ! ssh root@$IP " "; then
    echo -e "  >> ${RED}SSH connection failed${NOCOL}"
    echo ""
    continue
  fi
 
  #ssh root@10.65.4."${IP_last_digits[j-1]}" 
  #  echo 'file ambarella_sd.c +p' > /sys/kernel/debug/dynamic_debug/control
  #  tmux kill-session -t temp
  #  tmux kill-session -t 0
  #  tmux kill-session -t 1
  #  tmux new -d -s 0
  #  tmux send -t 0 'dmesg -w | grep -A 20 -B 20 error > /mnt/media/dmesg_mmc.txt' ENTER
  #"
 
  tmuxMsg=$(ssh root@$IP "tmux ls")
  if [[ $tmuxMsg == "" ]]; then
    echo -e "  >> ${YELLOW}NO TMUX SESSION FOUND. STARTING A NEW SESSION. ${NOCOL}"
    ssh root@10.65.4."${IP_last_digits[j-1]}" "
      echo 'file ambarella_sd.c +p' > /sys/kernel/debug/dynamic_debug/control
      tmux new -d -s 0
      sleep 1
      tmux send -t 0 'dmesg -w | grep -A 20 -B 20 error > /mnt/media/dmesg_mmc.txt' ENTER
      exit
    "
    echo ""
  fi
  
  tmux_ls=$(ssh root@$IP "tmux ls")
  echo "  >> $tmux_ls"

  
  string=$(ssh root@$IP "cat /mnt/media/dmesg_mmc.txt")
  if [[ $string == "" ]]; then
    echo "  >> No contents (or error) found in /mnt/media/dmesg_mmc.txt"
  else
    echo -e "  >> ${RED}ERROR FOUND. CHECK /mnt/media/dmesg_mmc.txt${NOCOL}"
  fi
  
  num_files=$(ssh root@$IP "ls -a /mnt/sdcard0/ | wc -l")
  if [[ $num_files == 0 ]]; then
    echo -e "  >> ${RED}ERROR: NO FILE FOUND IN THE SD CARD${NOCOL}"
  else
    echo "  >> Number of files in /mnt/sdcard0/ is $num_files"
  fi
  
  echo ""
  echo ""
done
