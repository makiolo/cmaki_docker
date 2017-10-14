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

curl https://raw.githubusercontent.com/dockcross/dockcross/master/Makefile -o dockcross-Makefile
for image in $(make -f dockcross-Makefile display_images); do
	echo "copy dockcross/$image to makiolo/$image (with script change)"
	echo "FROM dockcross/$image:latest" > Dockerfile
	echo "ENV DEBIAN_FRONTEND noninteractive" >> Dockerfile
	echo "RUN curl -s https://raw.githubusercontent.com/makiolo/cmaki_scripts/master/cmaki_depends.sh | bash" >> Dockerfile

	docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
	docker build . -t makiolo/$image
	docker push makiolo/$image
done

