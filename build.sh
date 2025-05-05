#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <vinkvfxls version> <releases-url>"
    exit 1
fi

echo Building vinkvfxls docker image...

json_data=$(curl -s ${2})

url=$(echo "$json_data" | jq -r --arg version "$1" '.releases[] | select(.version == $version) | .os_release.linux.url')
if [ -z "${url}" ]; then
    echo "Version '${1}' not found, make sure it matches the releases."
    exit 1
fi

checksum=$(echo "$json_data" | jq -r --arg version "$1" '.releases[] | select(.version == $version) | .os_release.linux.checksum')

echo "Fetching vinkvfxls from: $url"

filename=$(basename ${url})
download_directory="./build/${filename}"
mkdir -p build
curl -o ${download_directory} ${url}


calculated_checksum=$(sha256sum "$download_directory" | awk '{ print $1 }')

echo $calculated_checksum

if [ "$calculated_checksum" == "$checksum" ]; then
    echo "Checksum OK"
else
    echo "Checksum verification failed"
    echo "$calculated_checksum != $checksum"
    exit 1
fi


tar -zxvf $download_directory -C ./build

executable=./build/vinkvfxls-${1}-linux.run
chmod +x ${executable}
${executable} --skip-license --prefix=./build
mv ./build/bin/vinkvfxls ./

docker build . -t ghcr.io/vinkvfx/vinkvfxls:full-latest

slim build --http-probe-off --continue-after 1 --include-exe=curl --include-shell ghcr.io/vinkvfx/vinkvfxls:full-latest
docker tag ghcr.io/vinkvfx/vinkvfxls.slim:latest ghcr.io/vinkvfx/vinkvfxls:latest 
docker tag ghcr.io/vinkvfx/vinkvfxls.slim:latest ghcr.io/vinkvfx/vinkvfxls:${1}
