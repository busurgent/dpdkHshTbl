#!/bin/bash
sudo
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

