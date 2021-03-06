# SynoEnableSshLogin

This scripts enables SSH access for users that are not in the administrators group.

#### 1. Notes

- The script is able to automatically update itself using `git`.
- You pass the users in the following format `username:/path/to/homedir` (whereby `/path/to/homedir` is optional)

#### 2. Installation

##### 2.1 Install Git (optional)

- install the package `Git Server` on your Synology NAS, make sure it is running (requires sometimes extra action in `Package Center` and `SSH` running)
- alternatively add SynoCommunity to `Package Center` and install the `Git` package ([https://synocommunity.com/](https://synocommunity.com/#easy-install))
- you can also use `entware-ng` (<https://github.com/Entware/Entware-ng>)

##### 2.2 Install this script (using git)

- create a shared folder e. g. `sysadmin` (you want to restrict access to administrators and hide it in the network)
- connect via `ssh` to the NAS and execute the following commands

```bash
# navigate to the shared folder
cd /volume1/sysadmin
# clone the following repo
git clone https://github.com/alexanderharm/syno-enable-ssh-login
# to enable autoupdate
touch syno-enable-ssh-login/autoupdate
```

##### 2.3 Install this script (manually)

- create a shared folder e. g. `sysadmin` (you want to restrict access to administrators and hide it in the network)
- copy your `synoEnableSshLogin.sh` to `sysadmin` using e. g. `File Station` or `scp`
- make the script executable by connecting via `ssh` to the NAS and executing the following command

```bash
chmod 755 /volume1/sysadmin/synoEnableSshLogin.sh
```

#### 3. Setup

- run script manually

```bash
sudo /volume1/sysadmin/syno-enable-ssh-login/synoEnableSshLogin.sh  "<username 1>[:<homedir 1>]" "<username 2>[:<homedir 2>]"
```

*AND/OR*

- create a task in the `Task Scheduler` via WebGUI

```
# Type
Scheduled task > User-defined script

# General
Task:    SynoEnableSshLogin
User:    root
Enabled: yes

# Schedule
Run on the following days: Daily
First run time:            00:00
Frequency:                 Every 30 minute(s)
Last run time:				23:30

# Task Settings
Send run details by email:      yes
Email:                          (enter the appropriate address)
Send run details only when
  script terminates abnormally: yes
  
User-defined script: /volume1/sysadmin/syno-enable-ssh-login/synoEnableSshLogin.sh  "<username 1>[:<homedir 1>]" "<username 2>[:<homedir 2>]"
```
