#!/bin/bash

set -e

BASE_DIR=`dirname $0`

print_help(){
    cat <<EOH
Generates inventory for all-in-one deployment
usage: $0 <parameters> hostname
parameters:
  -d <path to dir where the inventory should be generated>, optional, default is root dir of script
  -u <name of application user>, optional, 'psapp' by default
  -p <password of application user>, optional, 'psapp' password by default
  -k <authorized key>, optional, authorized key is not set by default. When starts with @ then thread as pub file
  -h, print this help
EOH
    exit 1
}



out_dir=$BASE_DIR
application_user=psapp
application_password=psapp
authorized_key_item=

set_authorized_key_item() {
	key=$1
	echo key: $key
	
	if [[ $key =~ ^@.* ]]; then
		key=`cat ${key:1}`
	fi
	
	authorized_key_item='"'${key}'"'
}


while getopts "hd:k:u:p:" opt; do
  case $opt in
    d)
        out_dir=$OPTARG
        ;;
    d)
        application_user=$OPTARG
        ;;
    k)  
        set_authorized_key_item "$OPTARG"
        ;;
    p)
        application_password=$OPTARG
        ;;
    h)
        print_help;
        exit 1;
    ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1;
    ;;
  esac
done
shift $((OPTIND -1))



target_host=$1

if [ "x${target_host}x" == "xx" ]; then 
    echo Hosth where install should be defined!
    echo
    print_help
    exit 1
fi

mkdir -p "$out_dir"

echo Making hosts
cat << END_OF_FILE>"$out_dir/hosts"
[servicedesk]
vm1

END_OF_FILE


echo Making host_vars
mkdir -p "$out_dir/host_vars"
cat << END_OF_FILE>"$out_dir/host_vars/vm1.yml"
---
ansible_host: ${target_host}
...
END_OF_FILE



echo Making group vars
mkdir -p "$out_dir/group_vars"
cat << END_OF_FILE>"$out_dir/group_vars/servicedesk.yml"
---
application_user: '${application_user}'
application_password: '${application_password}'
authorized_keys: [${authorized_key_item}]
...
END_OF_FILE
