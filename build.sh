
set -ev

TAG=$(date "+%Y%m%d%H%M")

echo "The images will be tagged as $TAG"

if [ "$1" = "all" -o "$BUILD_ALL" = "true" ]
then
    docker build -t yglukhov/falcon-pre-nim:$TAG falcon-pre-nim
    docker push yglukhov/falcon-pre-nim:$TAG
fi

docker build -t yglukhov/falcon:$TAG falcon
docker push yglukhov/falcon:$TAG
