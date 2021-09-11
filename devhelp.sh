declare -A options

options["express"]="helpers/express.sh $2"

${options[$1]}

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


