## Koha Install
This is a bash script that install Koha, it was tested on:
- Debian 12 - bookworm
- Ubuntu 22.04 - jammy

## Running the script
```
chmod +x install_koha.sh
sudo ./install_koha.sh
```

### Post installation
The script will show the DNS records you need to create so, the website can be reached by using the server name.


## Documentation
This script was based on the the [Koha installation instructions for debian](https://wiki.koha-community.org/wiki/Koha_on_Debian) and uses the [Debian Packages for Koha repository](https://debian.koha-community.org/koha/).

Eventually you will need more commands to manage your Koha, learn how to use it [here](https://wiki.koha-community.org/wiki/Commands_provided_by_the_Debian_packages).