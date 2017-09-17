# cmaki_docker

multiple pusher of docker images.

for image in (windows-x86, windows-x64, linux-x86, linux-x64, ...)
  makiolo/$image = dockcross/$image + github:makiolo/cmaki_scripts/image.sh
done
