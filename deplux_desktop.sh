#!/bin/bash

# Goal: Script which automatically sets up a new Ubuntu Machine after installation
# This is a basic install, easily configurable to your needs.



#############################################################################################
#######################################    SCRIPT     #######################################
#############################################################################################

# Test to see if user is running with root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo 'Must execute with sudo or root' >&2
 exit 1
fi


####################################### LOG FILE #######################################
# add log file (moslty for practice in scripting) TODO

####################################### SYSTEM CHECKS #######################################

# Ensure system is up to date
echo "
Updating Linux..."
sudo apt-get update -qq
echo "Done updating Linux
"

# Upgrade the system
echo "Upgrading Linux..."
sudo apt-get upgrade -qq > /dev/null
echo "Done upgrading Linux
"

#################################### OS CUSTOMISATIONS #######################################

# .bashrc customisation TODO


# Message of the day TODO


# Rename home folder to remove capitalized letters TODO


################################### SECURITY / BASIC COMMS ###################################

# Install OpenSSH
echo "Installing OpenSSH..."
sudo apt-get install openssh-server -qq > /dev/null
echo "Done installing OpenSSH"
# Disabling root login over ssh
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
echo "Root login by ssh disabled 
"

# configure the firewall
echo "Setting up ufw..."
sudo ufw allow OpenSSH > /dev/null

# Enable Firewall
echo "Enabling ufw..."
sudo ufw enable > /dev/null
echo "Done setting up and enabling ufw
"

# Fail2Ban install
echo "Installing Fail2Ban..."
sudo apt-get install fail2ban -qq > /dev/null
sudo systemctl start fail2ban > /dev/null
sudo systemctl enable fail2ban &> /dev/null

echo "
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 4
" >> /etc/fail2ban/jail.local
echo "Done installing and setting up Fail2Ban
"

# more packages? TODO

####################################### TOOLS #######################################

# SpeedTest Install
echo "Installing speedtest-cli..."
sudo apt-get install speedtest-cli -qq > /dev/null
echo "Done installing Speedtest
"

# Exa Install
echo "Installing Exa..."
sudo apt-get install exa -qq > /dev/null

echo "alias ls='exa -l --color=always --group-directories-first'
alias la='exa -al --color=always --group-directories-first'
" >> ~/.bash_aliases
echo "Done installing Exa
"

# Neofetch install
echo "Installing Neofetch..."
sudo apt-get install neofetch -qq > /dev/null
echo "
neofetch
" >> ~/.bashrc
echo "Done installing Neofetch
"

# htop install
echo "Installing Htop..."
sudo apt-get install htop -qq > /dev/null
echo "Done installing Htop
"

# more packages? TODO

####################################### APPS #######################################

# Brave install
echo "Installing Brave..."
sudo apt-get install apt-transport-https curl -qq > /dev/null
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
|sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
sudo apt-get update -qq > /dev/null
sudo apt-get install brave-browser -qq > /dev/null
echo "Done installing Brave
"

# Discord install
echo "Installing Discord..."
sudo apt-get install discord -qq > /dev/null
echo "Done installing Discord
"

####################################### End of script #######################################

# Cleanup
sudo apt-get autoremove -qq > /dev/null
sudo apt-get clean -qq > /dev/null


# End message and notes #TODO
echo "
______________________________________________________________________________________________________

                                        End of Deplux!
______________________________________________________________________________________________________
"

exit 0
