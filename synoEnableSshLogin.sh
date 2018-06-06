#!/bin/bash

# check if run as root
if [ $(id -u "$(whoami)") -ne 0 ]; then
	echo "SynoEnableSshLogin needs to run as root!"
	exit 1
fi

# check if git is available
if command -v /usr/bin/git > /dev/null; then
	git="/usr/bin/git"
elif command -v /usr/local/git/bin/git > /dev/null; then
	git="/usr/local/git/bin/git"
elif command -v /opt/bin/git > /dev/null; then
	git="/opt/bin/git"
else
	echo "Git not found therefore no autoupdate. Please install the official package \"Git Server\", SynoCommunity's \"git\" or Entware-ng's."
	git=""
fi

# check for arguments
if [ -z $1 ]; then
	echo "No users passed to SynoEnableSshLogin!"
	exit 1
else
	echo "This was passed: $*."
	users=( "$@" )
fi

# save today's date
today=$(date +'%Y-%m-%d')

# self update run once daily
if [ ! -z "${git}" ] && [ -d "$(dirname "$0")/.git" ] && [ -f "$(dirname "$0")/autoupdate" ]; then
	if [ ! -f /tmp/.synoEnableSshLoginUpdate ] || [ "${today}" != "$(date -r /tmp/.synoEnableSshLoginUpdate +'%Y-%m-%d')" ]; then
		echo "Checking for updates..."
		# touch file to indicate update has run once
		touch /tmp/.synoEnableSshLoginUpdate
		# change dir and update via git
		cd "$(dirname "$0")" || exit 1
		$git fetch
		commits=$($git rev-list HEAD...origin/master --count)
		if [ $commits -gt 0 ]; then
			echo "Found a new version, updating..."
			$git pull --force
			echo "Executing new version..."
			exec "$(pwd -P)/synoEnableSshLogin.sh" "$@"
			# In case executing new fails
			echo "Executing new version failed."
			exit 1
		fi
		echo "No updates available."
	else
		echo "Already checked for updates today."
	fi
fi

# loop through passed users
for (( i=0; i<${#users[@]}; i++ )); do

	IFS=: read username homedir <<< "${users[$i]}"

    awk -i inplace -F ':' '
        BEGIN { OFS=":" }
        /^'${username}':/  {
            # replace shell
            if ($7!="/bin/sh") {
                sub(/.*/, "/bin/sh", $7)
                print("Enabled SSH login for user: \"'${username}'\".") > "/dev/stderr"
            }
            # replace homedir
            if ("'${homedir}'"!="" && $6!="'${homedir}'") {
                $6="'${homedir}'"
                print("Changed home dir for user: \"'${username}'\".") > "/dev/stderr"
            }
        }
        { print }
    ' /etc/passwd

done

# exit
exit 0