#!/bin/bash

# Goal: Script which automatically sets up a new Ubuntu Machine after installation
# This is a basic install, easily configurable to your needs.


#############################################################################################
#######################################   FUNCTIONS   #######################################
#############################################################################################

# Optional package install
optional_install() {
    
read -r -p "Do you want to install $optionalpkg? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo " 
    
        Installing $optionalpkg

    "
    sudo apt install $optionalpkg
    echo "
______________________________________________________________________________________________________    
                           $optionalpkg has been installed
______________________________________________________________________________________________________
"

else 
    echo "$optionalpkg won't be installed"
 
fi
}


#############################################################################################
#######################################   VARIBALES   #######################################
#############################################################################################

# List of optional packages
optionalpkgs=("discord" "") # TODO


#############################################################################################
#######################################    SCRIPT     #######################################
#############################################################################################

# Test to see if user is running with root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo 'Must execute with sudo or root' >&2
 exit 1
fi

####################################### SYSTEM CHECKS #######################################

# Ensure system is up to date
sudo apt update -y
echo "Updating Linux..."

# Upgrade the system
sudo apt upgrade -y
echo "Upgrading Linux..."

####################################### SECURITY / BASIC COMMS #######################################

# Install OpenSSH
echo "Installing OpenSSH..."
sudo apt install openssh-server -y

# SFTP Server / FTP server that runs over ssh TODO check settings
echo "Setting up SFTP..."
echo "
Match group sftp
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
" >> /etc/ssh/sshd_config

sudo service ssh restart  

# configure the firewall TODO add ftp?
echo "Setting up ufw..."
sudo ufw allow OpenSSH

# Enable Firewall
echo "Enabling ufw..."
sudo ufw enable 

# Disabling root login 
echo "PermitRootLogin no" >> /etc/ssh/sshd_config 
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Fail2Ban install
echo "Installing Fail2Ban..."
sudo apt install -y fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

echo "
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 4
" >> /etc/fail2ban/jail.local


####################################### TOOLS #######################################

# SpeedTest Install
echo "Installing speedtest-cli..."
sudo apt install speedtest-cli -y

# Exa Install
wget -q -P /tmp/ http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_amd64.deb
echo "Installing Exa..."
sudo apt install /tmp/exa_0.9.0-4_amd64.deb
rm /tmp/exa_0.9.0-4_amd64.deb

echo "" >> ~/.bash_aliases # TODO

# Neofetch install
echo "Installing Neofetch..."
sudo apt install neofetch -y
echo "
neofetch
" >> ~/.bashrc

# htop install
echo "Installing Htop..."
sudo apt install htop -y


####################################### OS CUSTOMISATIONS #######################################

# .bashrc customisation TODO


# Message of the day TODO


# Rename home falder to remove capitalized letters TODO



####################################### APPS #######################################

# Brave install
sudo apt install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y

# Discord install
echo "Installing Discord..."
sudo apt install discord -y


####################################### End of script #######################################

# Cleanup
sudo apt autoremove -y
sudo apt clean -y

# End message and notes #TODO
echo "
______________________________________________________________________________________________________

                                        End of Deplux!

                                            Notes

In order to

______________________________________________________________________________________________________
"

exit 0

