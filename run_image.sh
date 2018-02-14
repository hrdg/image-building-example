SHARED_IMAGE="$1"
COURSE_IMAGE="$2"
RUN_CMD="$3"

# Documentation ---------------------------------------------------------------
if [ -z $1 ]
then
    echo "
This script lets you test out a DataCamp course image, using a specified
shared image. Example Usage:

$0 shared-r:55652c588ac496e54f16077175b42715 course-5334-master:1fe93b74ae61546fedc0e447d2b2e84c
"
    exit
fi

if [ -z $RUN_CMD ]
then
    echo "No run command (third argument) specified, will use container's default behavior."
    echo "Use '/bin/bash' as argument to use terminal inside container"
fi

# Build and run images --------------------------------------------------------

printf "\n\nRemoving dc_shared container ----\n"

docker rm dc_shared || true


printf "\n\nCreating shared volume: dc_shared ----\n"

#R_LIBS_SITE: '/usr/local/lib/R/site-library:/var/lib/R/shared_libs'
#/var/lib/python/site-packages
#/var/lib/R/shared_libs
#docker create -v /var/lib/R/shared_libs --name dc_shared \
docker create -v /var/lib/python/site-packages --name dc_shared \
    dockerhub.datacamp.com:443/"$SHARED_IMAGE" \
    bin/true

printf "\n\nRunning course container ----\n"

docker build -t conda .

docker run -p 3001:3000 -it -m 800M --volumes-from dc_shared:ro \
    -e PROXYTOKEN=hey \
    -e R_LIBS_SITE="/usr/local/lib/R/site-library:/var/lib/R/shared_libs" \
    conda $RUN_CMD


