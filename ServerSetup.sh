#!/bin/bash

# Separate dependencies with space
depends="git wget apt-transport-https gnupg lsb-release screen"

install_java(){
    echo "Installing AdaptOpenJDK 8"
    # Import AdoptOpenJDK GPG key
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
    # Add APT repository
    [ ! -f /etc/apt/sources.list.d/adoptopenjdk.list ] && printf 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb %s main\n' "$(lsb_release -sc)" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
    sudo apt-get update
    sudo apt-get -y install adoptopenjdk-8-hotspot
}

setup(){
    # Make sure on Debian by checking if apt exists
    if ! type apt-get > /dev/null; then echo "Error: This script only supports Debian/Ubuntu-based distros."; exit 1; fi

    # Make sure sudo is installed
    if ! type sudo > /dev/null; then echo "Error: The sudo command is required, but we're not going to install it. Please make sure you have the sudo command, and permission to use it. "; exit 1; fi

    # Installing dependencies
    sudo apt-get -y install $depends
    
    check_java

}

# Check if Java installed
check_java(){
    echo "Checking for Java"
    if ! java -v COMMAND &> /dev/null
    then
        echo "Java not found." 
        
        while true; do
            read -p "Would you like to install AdaptOpenJDK 8? " yn
            case $yn in
                [Yy]* ) install_java; break;;
                [Nn]* ) echo "Please install Java and run script again. "; break;;
                * ) echo "WARNING: You chose not to install Java, so the server may not run. ";;
            esac
        done
    fi
    
    
}

setup