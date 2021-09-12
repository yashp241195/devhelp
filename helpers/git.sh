declare -A helper
declare -A hint

hint["git-basic"]="Create and Upload git repository"
helper["git-basic"]="
hint : ${hint["git-basic"]}

// initialize the folder as git repository
$ git init

// add particular file to git 
$ git add file.txt

// add all files in the directory with
$ git add .

// check which branch you are presently in
$ git branch --list

// commit to git current branch
$ git commit -m 'first commit'

// Create the branch
$ git branch mybranch

// Delete the branch 
$ git branch -d mybranch

// Switch to mybranch
$ git checkout mybranch

// merge branchA from branchB
$ git checkout branchA
// switched to branchA ..
$ git merge branchB
// branch B is merged into branch A 

"

hint["git-github"] = "Pushing the code to github"
helper["git-github"]="
hint : ${hint["git-github"]}

// add the remote url to origin variable
$ git remote add origin http://github.com/user/repo

// pushing the files into the main branch
$ git push origin main

"

echo "${helper[$1]}"

if [[ $1 == "--list" ]];
then 
for i in "${!hint[@]}"; do echo "$i - ${hint[$i]}"; done
elif [[ $1 == "--all" ]];
then
echo ""
fi
echo " "

