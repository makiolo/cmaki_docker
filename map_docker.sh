#/bin/bash
prefix=$(pwd)/bin
mkdir -p $prefix

# iterate in known images
curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o dockcross-Makefile
for image in $(make -f dockcross-Makefile display_images); do
	if [[ $(docker images -q dockcross/$image) != "" ]]; then
		docker rmi -f dockcross/$image
		echo dockcross/$image removed.
	fi
done

# curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o dockcross-Makefile
# for image in $(make -f dockcross-Makefile display_images); do

image=windows-x86
echo "copy dockcross/$image to makiolo/$image (with script change)"
docker pull -a makiolo/$image
docker run dockcross/$image > $prefix/dockcross-$image && chmod u+x $prefix/dockcross-$image
$prefix/dockcross-$image bash -c 'curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/image.sh | bash'
last_layer=$(docker ps -l -q)
echo last layer: ${last_layer}
docker commit $last_layer dockcross/$image:latest
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker push makiolo/$image

# done
