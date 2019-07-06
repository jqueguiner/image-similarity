current_dir="${PWD##*/}"

usage="$(basename "$0") [-h] [-f i c p n] -- build and run your docker

where:
    -h  show this help text
    -f  set the dockerfile to build | default \"Dockerfile\"
    -i  interactive mode once docker is launched | default \"y\"
    -c  force no-cache mode for docker | default \"no\"
    -p  docker port | default 5000
    -n  nvidia-docker | default \"no\"
    "

dockerfile='Dockerfile'
interactive='y'
nocache=''
port=5000
nvidia='n'
while getopts ':hficpn:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    f) dockerfile=$OPTARG
       ;;
    i) interactive=$OPTARG
       ;;
    c) nocache=$OPTARG
       ;;
    p) port=$OPTARG
       ;;
    n) nvidia=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))


case $interactive in
  [yYoO]*)
	echo "Running in interactive mode"
    sed -i '' 's/ENTRYPOINT/#ENTRYPOINT/g' $dockerfile
    sed -i '' 's/CMD/#CMD/g' $dockerfile
    ;;
  *)   
	sed -i '' 's/#ENTRYPOINT/ENTRYPOINT/g' $dockerfile
    sed -i '' 's/#CMD/CMD/g' $dockerfile
    ;;
esac



case $nocache in
  [yYoO]*)
	echo "Building in no-cache mode"
    docker build -t $current_dir --no-cache -f $dockerfile .
    ;;
  *)   
	docker build -t $current_dir -f $dockerfile . 
	;;
esac

case $nvidia in
  [yYoO]*)
	echo "Running with nvidia-docker"
    nvidia-docker run -ipc=host -it -p $port:5000 $current_dir
    ;;
  *)
	docker run -it -p $port:5000 $current_dir
	;;
esac



