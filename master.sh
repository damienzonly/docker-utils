VERSION=1.0.0
CONTAINER_NAME=$1
START_DIR=$(pwd)
RETRY=0
DEBUG=0
function help () {
    echo "Usage: $0 [OPTIONS] container1 [,containers...]"
    echo "      -h display help message"
    echo "      -r when a container from the list is not found, retry until it runs"
    echo "      -d debug: remove log files created by the script"
    echo "      -v version: print $0 version"
}

while getopts ":rdvh" option; do
    case $option in
        r)
            echo "Retry enabled"
            RETRY=1
            ;;
        d)
            DEBUG=1
            echo "Debug mode"
            ;;
        v)
            echo $VERSION
            exit
            ;;
        h)
            help
            exit
            ;;
        *)
            help
            exit
            ;;
    esac
done
shift "$((OPTIND-1))"

function c_id () {
    # get container id from name
    C_ID=$(docker ps | grep $1 | awk '{print $1}')
}

function inspect() {
    local container=$1
    c_id $container
    if [ $RETRY -eq 1 ]; then
        while [ -z "$C_ID" ]; do
            echo "$container not found"
            sleep 1
            c_id $container
            continue
        done
    elif [ -z "$C_ID" ]; then
        echo "$container not found, skipping..."
        return
    fi
    rm -rf $container.log
    echo "$container ID: $C_ID"
    cd /var/lib/docker/containers
    cd $C_ID*
    ln ${C_ID}* "$START_DIR/$container.log"
    cd $START_DIR
}

for container in "$@"; do
    echo inspecting $container...
    inspect $container
done

if [ "$DEBUG" = "1" ];
then
    rm -rf *.log
else
    ls -l *.log 2> /dev/null
fi

echo "Done!"
