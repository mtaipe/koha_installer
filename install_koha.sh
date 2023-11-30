#!/bin/bash

# Get library name and domain from the user
read -p "Enter the library name: " library_name
read -p "Enter the domain (e.g., example.com): " domain

# Check if the GPG key file exists, and fetch it if not
gpg_key_file="/usr/share/keyrings/koha-keyring.gpg"
if [ ! -f "$gpg_key_file" ]; then
    wget -qO - https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o "$gpg_key_file"
fi

# Add Koha repository
echo "deb [signed-by=$gpg_key_file] https://debian.koha-community.org/koha stable main" > /etc/apt/sources.list.d/koha.list

# Update the system
apt-get update
apt-get upgrade -y

# Install MariaDB, Systemd and 
apt-get install -y mariadb-server systemd systemctl

# Download and install Koha
apt-get install -y koha-common

# Configure Apache for Koha
a2enmod rewrite
a2enmod cgi
systemctl restart apache2

# Customize configuration file
sed -i "s/DOMAIN=.*/DOMAIN=\"\.$domain\"/" /etc/koha/koha-sites.conf

# Set up the Koha instance
koha-create --create-db $library_name

# Start services
systemctl start mariadb
systemctl enable mariadb
systemctl start koha-common
systemctl enable koha-common
systemctl start apache2
systemctl enable apache2

ip_address=$(hostname -I | awk '{print $1}')


user=$(xmlstarlet sel -t -v 'yazgfs/config/user' /etc/koha/sites/$library_name/koha-conf.xml);
passwd=$(xmlstarlet sel -t -v 'yazgfs/config/pass' /etc/koha/sites/$library_name/koha-conf.xml);
echo ""
echo "***************** One More step ******************"
echo ". Create two DNS records:"
echo ". '$library_name.$domain' poiting to $ip_address"
echo ". '$library_name-intra.$domain' poiting to $ip_address"
echo "."
echo ". Or add this line into /etc/hosts or C:\windows\system32\drivers\etc\hosts"
echo ". $ip_address   $library_name.$domain $library_name-intra.$domain"
echo "."
echo "***************** Accesing Koha ******************"
echo ". You can access Koha at http://$library_name-intra.$domain"
echo ". username is: $user"
echo ". password is: $passwd"
echo "."
