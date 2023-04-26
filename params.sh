: '
This file contains parameters for the scripts you will need for hdram loading
log checking so that you can only modify this parameter script to update 
camera info such as IP or label rather than each associated script when you need to
start a new test
'

# Common part of the IP
IP_COMMON="10.1.24."

# Unique part of IP for each camera
IP_last_digits=(
  '125' '117' '118' '120' '122'
  '127' '114' '116' '110' '140'
  '135' '136' '130' '131' '132'
  '107' '53' '103' '108' '104'
  '124' '119' '147' '134' '123'
  '115' '109' '106' '105' '102'
  '99' '142' '133' '141' '137'
  '148'
)

# Labels for the cameras
CAMERA_LABEL=(
  '1' '2' '3' '4' '5'
  '6' '7' '8' '9' '10'
  '11' '12' '13' '14' '17'
  '18' '19' '20' '21' '22'
  '23' '24' '28' '29' '30'
  '31' '32' '33' '34' '35'
  '36' '37' '38' '39' '40'
  '41'
)

# Name of the output csv file
CSV_Filename="hdram_log.csv"
