#!/bin/bash
# Copyright Christoph Helms, Jan 2023

#### VARIABLES
capturedir="/media/dvcapture/DVCAPTURE/miniDV Footage"
NC='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White


#### MAIN SCRIPT
clear
echo -e "Welcome to DV capture!\n\nThis program allows you to batch capture miniDV tapes through Firewire."
echo -e "\n\n${Purple}You can decide if you want your tapes to be named automatically. \nIn this case your files will look like this: dvgrab-2004.05.26_18-03-15.dv"
echo -e "\nWe will use the time the tape was originally captured as the file name.\nFor more control you can also name your folders in which the files go."
echo -e "\nYou can quit this program at any time by pressing Ctrl+c.\n\n\n${NC}Please connect Camera and insert Tape."
read -s -n 1 -p "Press any key to continue..."
if [ ! -d "$capturedir" ]; then
	capturedir=~
	echo -e "\n\n\nPlease note: Capture Directory is set to $(echo $capturedir)."
	echo -e "\nIf you would like another location, please open this script in an editor and update capturedir on line 5"
fi
if dvgrab 2>/dev/null; then
	echo -e "\n\nCamera detected. Continuing...\n"
	read -p "Do you want to name your tapes? [Y/N]" yn
	case $yn in
		[yY] ) 
			while :; do
				echo -e "\nPlease choose tape name:\n"
				read fname
				if [[ "$capturedir" ]]; then
					mkdir -p "$capturedir/$fname"
					echo -e "\nStarting tape capture process now. Rewinding tape first..."
					cd "$capturedir/$fname"
					dvgrab -showstatus -t -a -rewind
					echo -e "\nFolder created on DVCAPTURE drive: $fname with the following content: $(ls "$capturedir/$fname")"
					echo -e "${Green}\nFree space left on device: $(df -h "$capturedir" | tail -n1 | awk '{print $4}')${NC}"

				fi
			done
			break;;
		[nN] )
			while :; do
				echo -e "\nPlease insert new tape."
				read -s -p "Press any key to continue... (Exit with Ctrl+c)"
				cd "$capturedir"
				dvgrab -showstatus -t -a -rewind
				echo -e "${Green}\nFree space left on device: $(df -h "$capturedir" |tail -n1 | awk '{print $4}')${NC}"
			done
			break;;
		* ) echo -e "\nInvalid Response. Choose Y or N"
	esac
else
	echo -e "\n\n${Red}No camera detected. Please connect firewire cable to camera. \nSwitch camera on and insert miniDV tape${NC}"
fi
