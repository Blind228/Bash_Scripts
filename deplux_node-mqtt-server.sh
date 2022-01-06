#!/bin/bash

# Goal: Script which automatically sets up a new raspbian server after installation
# This is a basic install, easily configurable to your needs.

# Packages that are automatically installed and setup:
#   - Node-Red
#   - Mosquitto (MQTT broker)
#   - MongoDB


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

# Install firewall
sudo apt-get install ufw -qq > /dev/null
# configure firewall
echo "Setting up ufw..."
sudo ufw allow OpenSSH > /dev/null
# Enable Firewall
echo "Enabling ufw..."
sudo ufw enable > /dev/null
echo "Done setting up and enabling ufw
"

# more packages? TODO

####################################### TOOLS #######################################

# Exa Install
echo "Installing Exa..."
wget -q -P ~/downloads   http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_amd64.deb
sudo apt-get install ~/downloads/exa_0.9.0-4_amd64.deb -qq > /dev/null

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

# Node-Red install
echo "Installing Node-Red..."
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --confirm-install --confirm-pi --nodered-user=$USER
echo "Done installing Node-Red
"
# Node-Red  setup
sudo systemctl enable nodered.service --quit
echo "Done setting up and enabling Node-Red
"

# Mosquitto install
echo "Installing Mosquitto..."
sudo apt-get install mosquitto mosquitto-clients -qq > /dev/null
echo "Done installing Mosquitto
"
# Mosquitto setup
echo "
listener 1883
allow_anonymous true
" >> /etc/mosquitto/conf.d/default.conf
sudo systemctl enable mosquitto.service --quit
echo "Done setting up and enabling Mosquitto
"

# MongoDB install
echo "Installing MongoDB..."
sudo apt-get install mongodb -qq > /dev/null
echo "Done installing MongoDB
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

