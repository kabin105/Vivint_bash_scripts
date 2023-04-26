#!/bin/bash
source params.sh # Include the parameters

rm ~/.ssh/known_hosts # Clear known_hosts to prevent mix-ups of duplicate IPs from the previous test

for ((j = 1; j <= "${#IP_last_digits[@]}"; j++)); do
  IP=$IP_COMMON"${IP_last_digits[j-1]}"
  echo "Camera number ${CAMERA_LABEL[j-1]} ($IP)"
  
  if [ -z "$(ssh-keygen -F $IP)" ]; then
    ssh-keyscan -H $IP >> ~/.ssh/known_hosts
  fi
  echo "" # New line
done
