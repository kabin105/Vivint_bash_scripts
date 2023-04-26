#!/bin/bash
source params.sh # Include the parameters

# These arrays will be used for a .csv file
gclk_sdxc=()
gclk_sdio=()
gclk_sd=()
Kernel_Panics=()
Memtest_Fails=()
DM_Verity_Runs=()
DM_Verity_Fails=()
Reboots=()

for ((i = 1; i <= "${#IP_last_digits[@]}"; i++)); do
  IP=$IP_COMMON"${IP_last_digits[i-1]}" # Complete IP for each camera
  
  echo "Camera ${CAMERA_LABEL[i-1]} ($IP)"
  
  # Store each word of the output of zdata_compile.sh in an array
  # Word here just means things that are seperated by space in the output
  zdata_output=()
  string=$(ssh root@$IP "/mnt/sdcard0/zdata_compile.sh")
  
  # If the output string is empty then it means either the camera is unable to ssh or sd card is empty
  if [[ "$string" == "" ]]; then
    ping=$(ping -c 5 $IP) # ping five times
    received=$(grep "0 received" <<< $ping) # 0 received means there is no connection. Otherwise, it must be sd error
    
    # If received strong is not empty, it did receive nothing, which means ssh error
    if [[ $received != "" ]]; then
      gclk_sdxc+=("Can't ssh")
      gclk_sdio+=("Can't ssh")
      gclk_sd+=("Can't ssh")
      Kernel_Panics+=("Can't ssh")
      Memtest_Fails+=("Can't ssh")
      DM_Verity_Runs+=("Can't ssh")
      DM_Verity_Fails+=("Can't ssh")
      Reboots+=("Can't ssh")
    # If there is something received when the zdata output string is not empty, it must be sd error
    else
      gclk_sdxc+=("SD error")
      gclk_sdio+=("SD error")
      gclk_sd+=("SD error")
      Kernel_Panics+=("SD error")
      Memtest_Fails+=("SD error")
      DM_Verity_Runs+=("SD error")
      DM_Verity_Fails+=("SD error")
      Reboots+=("SD error")
    fi
  fi
  
  # In case of an empty string (unable to ssh) the array will be empty too
  for s in $string; do
    zdata_output+=("$s")
  done

  # Iterate through array of words
  # This loop won't run if the string is empty
  for ((j = 0; j < "${#zdata_output[@]}"; j++)); do
    # Is "gclk_sdxc:" is found, the next word is the value of it
    if [[ "${zdata_output[j]}" == "gclk_sdxc:" ]]; then
      echo "gclk_sdxc: ${zdata_output[j+1]}" # Print in the terminal
      gclk_sdxc+=("${zdata_output[j+1]}") # Append to the array for the .csv file
    
    # Same as above for "gclk_sdio:"
    elif [[ "${zdata_output[j]}" == "gclk_sdio:" ]]; then
      echo "gclk_sdio: ${zdata_output[j+1]}"
      gclk_sdio+=("${zdata_output[j+1]}")
    
    # Same as above for "gclk_sd:"
    elif [[ "${zdata_output[j]}" == "gclk_sd:" ]]; then
      echo "gclk_sd: ${zdata_output[j+1]}"
      gclk_sd+=("${zdata_output[j+1]}")
    
    # If it sees "Total" (FYI there will be two "Total"s in the output)
    elif [[ "${zdata_output[j]}" == "Total" ]]; then
      # and if the next word is "Memtest" the 3 words after is Memtest Fail
      if [[ "${zdata_output[j+1]}" == "Memtest" ]]; then
        echo "Memtest Fails: ${zdata_output[j+3]}"
        Memtest_Fails+=("${zdata_output[j+3]}")
      fi  
      
    # Check Kernel Panic
    elif [[ "${zdata_output[j]}" == "Memtest" ]] && [[ "${zdata_output[j-1]}" != "Total" ]]; then
      echo "Kernal Panics: ${zdata_output[j-1]}" 
      Kernel_Panics+=("${zdata_output[j-1]}")
      
    elif [[ "${zdata_output[j]}" == "Dm-Verity" ]]; then
      if [[ "${zdata_output[j+1]}" == "Runs" ]]; then
        echo "Dm-Verity Runs: ${zdata_output[j+2]}"
        DM_Verity_Runs+=("${zdata_output[j+2]}")
      elif [[ "${zdata_output[j+1]}" == "Corrupt" ]]; then
        echo "Dm-Verity Fails: ${zdata_output[j+3]}"
        DM_Verity_Fails+=("${zdata_output[j+3]}")
      fi
    
    elif [[ "${zdata_output[j]}" == "Reboots" ]]; then
      echo "Reboots: ${zdata_output[j+1]}"
      Reboots+=("${zdata_output[j+1]}")
    fi
  done
  
  echo ""
done

rm ./$CSV_Filename # Remove the file so we only keep the current data instead of appending to the previous one

## Write the data to a .csv file for copy-paste ##

# Write the column names. This will be in the order of the how it is oredered in the spreadsheet for data recording
echo "'camera Number', 'Memtest Fail', 'DM-Verity Runs', 'DM-Verity Fails', 'Kernal Panic', 'Reboots', 'gclk_sdxc', 'gclk_sdio', 'gclk_sd'" >> $CSV_Filename

# Write the values to the file
for ((i = 1; i <= "${#IP_last_digits[@]}"; i++)); do
  cam_num=${CAMERA_LABEL[i-1]}
  echo "Camera $cam_num, ${Memtest_Fails[i-1]}, ${DM_Verity_Runs[i-1]}, ${DM_Verity_Fails[i-1]}, ${Kernel_Panics[i-1]}, ${Reboots[i-1]}, ${gclk_sdxc[i-1]}, ${gclk_sdio[i-1]}, ${gclk_sd[i-1]}" >> $CSV_Filename
done
