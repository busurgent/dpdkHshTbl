#!/bin/bash
sudo
echo "This is home-made application... Do you want to proceed?[y,n]"
read input
if [ "$input" = "y" ] || [ "$input" = "Y" ]; then
	echo "You chose to proceed."
	sudo apt-get update
	if ! command -v curl &> /dev/null
	then
		echo "curl is not installed. Installing..."
		sudo apt-get install -y curl
	else
		echo "curl is already installed."
	fi

	if ! command -v tar &> /dev/null
	then
		echo "tar is not installed. Installing..."
		sudo apt-get install -y tar
	else
		echo "tar is already installed."
	fi

	if ! command -v meson &> /dev/null
	then
		echo "meson is not installed. Installing..."
		sudo apt-get install -y meson
	else
		echo "meson is already installed."
	fi

	if ! command -v ninja &> /dev/null
	then
		echo "ninja is not installed. Installing..."
		sudo apt-get install -y ninja-build
	else
		echo "ninja is already installed."
	fi
elif [ "$input" = "n" ] || [ "$input" = "N" ]; then
	echo "OK. Maybe later)"
else
	echo "Whaat?..."
fi

