declare -A options

# Install guide .. 
# create the file in 
# $ sudo gedit /usr/bin/devhelp
# add the below code to the "devhelp" file, basically add the path to devhelp folder
# /home/yash/Desktop/myapps/devhelp/devhelp.sh $1 $2
# save the file
# $ sudo chmod +x /usr/bin/devhelp
# done !!
# Now run the devhelp from anywhere 

# get the current directory of this bash script 
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

options["express"]="helpers/express.sh"

$SCRIPT_DIR/${options[$1]} $2

if [[ $1 == "--list" ]];
then 
for i in "${!options[@]}"; do echo " $i "; done
elif [[ $1 == "--help" ]];
then
echo "
Welcome to devhelp, a command line helper tool for faster development
--list : list of all helpers
"
fi


