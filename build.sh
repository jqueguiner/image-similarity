current_dir="${PWD##*/}"
dockerfile=$1
interactive=$2
nocache=$3

if [ $interactive = "y" ]
then
    echo "Running in interactive mode"
    sed -i '' 's/ENTRYPOINT/#ENTRYPOINT/g' $dockerfile
    sed -i '' 's/CMD/#CMD/g' $dockerfile
else
    sed -i '' 's/#ENTRYPOINT/ENTRYPOINT/g' $dockerfile
    sed -i '' 's/#CMD/CMD/g' $dockerfile
fi

if [ nocache = "" ]
then
    docker build -t $current_dir -f $dockerfile .
else
    echo "Building in no-cache mode"
    docker build -t $current_dir --no-cache -f $dockerfile .
fi

docker run -it -p 5000:5000 $current_dir
