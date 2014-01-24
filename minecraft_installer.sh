#!/bin/bash 
declare -i version
version=`./minecraft -v`

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
		echo -e "[Desktop Entry]\nName=Minecraft\nComment=Punching Trees\nExec=minecraft\nIcon=/usr/share/pixmaps/minecraft.png\nCategories=Game" > /tmp/minecraft.desktop
		mv /tmp/minecraft.desktop /usr/share/applications/minecraft.desktop
		chmod +x /usr/share/applications/minecraft.desktop
}

upgrademinecraft() {
	versioninstalled=`/usr/games/minecraft -version`
	mv /usr/games/minecraft "$PWD/minecraft.$versioninstalled"
	cp $PWD/minecraft /usr/games/
	echo "Upgrade Complete"
}

if [[ $UID -eq 0 ]] ; then #checks for root 
	
	if [ -e "/usr/local/games/minecraft" ] ; then #testing to see if you have minecraft  installed already
			versioninstalled=`/usr/games/minecraft -v`
			if [[ $versioninstalled -ge $version ]] ; then
				echo "No need to install or update"

			elif [[ $versioninstalled -lt $version ]] ; then
				installminecraft
			fi
	elif [[ ! -e "/usr/local/games/minecraft" ]] ; then
		echo "Installing Minecraft"
		installminecraft
	fi
else
  echo "Must be run as root"
fi
