#!/bin/bash 
declare -i version
version=`./minecraft -v | sed "s/\./0/"` #the sed removes the . in the floating point allowing it to be read as an int

installminecraft() {
		printf "creating directorys %s\n"
		mkdir -p /usr/local/games/minecraft #the downloading bit of the script. 
		printf "grabbing launcher %s\n"
		wget -O /usr/local/games/minecraft/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar
		wget -O /usr/share/pixmaps/minecraft.png http://media-mcw.cursecdn.com/c/c5/Grass.png
		wget -O /usr/local/games/minecraft/textureender.jar https://s3.amazonaws.com/Minecraft.Download/utilities/TextureEnder.jar
		wget -O /usr/local/games/minecraft/unsticher.jar http://assets.minecraft.net/unstitcher/unstitcher.jar
		chmod +x ./minecraft
		cp ./minecraft /usr/games/
		printf "[Desktop Entry]\nName=Minecraft\nComment=Punching Trees\nExec=minecraft\nIcon=/usr/share/pixmaps/minecraft.png\nCategories=Game;" > /tmp/minecraft.desktop
		mv /tmp/minecraft.desktop /usr/share/applications/minecraft.desktop
		chmod +x /usr/share/applications/minecraft.desktop
		exit 0
}

upgrademinecraft() {
	versioninstalled=`/usr/games/minecraft -version`
	mv /usr/games/minecraft "$PWD/minecraft.$versioninstalled"
	cp $PWD/minecraft /usr/games/
	printf "Upgrade Complete\n"
	exit 0
}

if [[ $UID -eq 0 ]] ; then #checks for root 
	
	if [ -e "/usr/local/games/minecraft" ] ; then #testing to see if you have minecraft  installed already
			versioninstalled=`/usr/games/minecraft -v | sed "s/\./0/"`
			if [[ $versioninstalled -ge $version ]] ; then
				printf "No need to install or update\n"
				exit 0
			elif [[ $versioninstalled -lt $version ]] ; then
				installminecraft
			fi
	elif [[ ! -e "/usr/local/games/minecraft" ]] ; then
		echo "Installing Minecraft"
		installminecraft
	fi
else
  echo "Must be run as root"
  exit 1
fi
