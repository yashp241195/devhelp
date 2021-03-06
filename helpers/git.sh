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

// ignore files for commit with .gitignore
// by mentioning things you wish to ignore

// inside .gitignore (for example in any node project)
node_modules

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

hint["git-github"]="Pushing the code to github"

helper["git-github"]="
hint : ${hint["git-github"]}

// add the remote url to origin variable (SSH)
$ git remote add origin git@github.com:yashp241195/devhelp.git

// if origin already exists you can remove origin and add new origin again
$ git remote remove origin

// create the SSH Keys pair for committing to github
ssh-keygen -t ed25519 -C 'git@github.com:yashp241195/devhelp.git'

// this will create two keys github (private) and github.pub (public) keys.
// add key.pub data to github account key (private) into your local directory
// from where you want to push the code to your github

$  eval ssh-agent
$  ssh-add /home/yash/Desktop/myapps/keys/github

github

$ sudo env SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add /home/yash/Desktop/myapps/keys/github

gitlab 

$ sudo env SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add /home/yash/Desktop/myapps/keys_gl/glkey


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

