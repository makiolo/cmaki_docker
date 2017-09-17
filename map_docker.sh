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
# 	# echo "Pulling dockcross/$image"
# 	# docker pull dockcross/$image
# 	echo "$prefix/dockcross-$image ok"
# 	docker run dockcross/$image > $prefix/dockcross-$image && chmod u+x $prefix/dockcross-$image
# done

image=windows-x86
docker pull makiolo/$image
echo "$prefix/dockcross-$image ok"
docker run dockcross/$image > $prefix/dockcross-$image && chmod u+x $prefix/dockcross-$image
$prefix/dockcross-$image bash -c 'sudo apt install -y cmake'
last_layer=$(docker ps -l -q)
echo last layer: ${last_layer}
docker commit $last_layer dockcross/$image:latest
# docker build -t dockcross/$image:latest .
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker push makiolo/$image

