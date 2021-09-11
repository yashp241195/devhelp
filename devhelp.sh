declare -A options

options["express"]="helpers/express.sh $2"
options["react"]="helpers/react.sh $2"

${options[$1]}

