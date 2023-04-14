#!/usr/bin/env bash

set -xeuo pipefail

usage() {
  cat <<'EOT'
build.sh --name LAYER_DIR_NAME --arch [amd64|arm64]

  --name directory having pyproject.toml in layers (ex. layer/base
  --arch CPU architecture
EOT
}

layer_name=""
architecture=""

for args in "$@"; do
  case $args in
    '--name')
      layer_name=$2
      ;;
    '--arch')
      architecture=$2
      ;;
    '--help')
      usage
      exit 0
      ;;
  esac
  shift
done

if [[ -z "${layer_name}" || -z "${architecture}" ]]; then
  usage
  exit 1
fi

cd "layers/$layer_name"
poetry export > requirements.txt

docker image build -f ../../Dockerfile -t $layer_name --platform linux/$architecture .
docker container run --name=$layer_name $layer_name
docker container cp $layer_name:/tmp/layer/python .
docker container rm $layer_name
docker image rm $layer_name
