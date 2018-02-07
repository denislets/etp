#!/bin/bash


print_help(){
    cat <<EOH
Run integarion tests in container.
usage: $0 <parameters>
parameters:
  -t <target host where the servicedesk application is running>, optional, default is localhost
  -p <target port where the servicedesk application is running>, optional, default is 8080
  -l <path to logs>, optional, default is ./logs
  -v print the version and exit
  -h, print this help and exit
EOH
    exit 1
}

this_dir=`dirname $0`

servicedesk_host=localhost
servicedesk_port=8080
servicedesk_version=`cat ${this_dir}/version.txt`
logs_dir=./logs

while getopts "hvp:t:l:" opt; do
  case $opt in
    t)
        servicedesk_host=$OPTARG
        ;;
    p)
        servicedesk_port=$OPTARG
        ;;
    l)
        logs_dir=$OPTARG
        ;;
    v)
        echo ${servicedesk_version}
        exit 0;
        ;;
    h)
        print_help;
        exit 0;
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1;
        ;;
  esac
done


if [ "x${servicedesk_host}x" == "xx" ]; then 
    echo Host of the servicedesk application is not defined!
    echo
    print_help
    exit 1
fi

if [ "x${servicedesk_port}x" == "xx" ]; then 
    echo Host of the servicedesk application is not defined!
    echo
    print_help
    exit 1
fi

echo "Running in:" `pwd`
echo servicedesk_host:    ${servicedesk_host}
echo servicedesk_port:    ${servicedesk_port}
echo servicedesk_version: ${servicedesk_version}



mkdir -p ${logs_dir}


base_url="http://${servicedesk_host}:${servicedesk_port}/servicedesk-service-${servicedesk_version}/health/check"
echo base_url: ${base_url}

test_number=1
test_results=


test_status_is_ok(){
	status=`cat $1|head -1|tr '\n' ' '|tr '\r' ' '`
	echo "${test_number}: Test if '${status}' contains '200 OK'" 
	echo ${status}|grep -F '200 OK'>/dev/null
	test_results=${test_results}$?
	test_number=$((test_number+1))
	return 0
}

test_body() {
	body=`cat $1|tail -1`
	echo "${test_number}: Test if '${body}' is '$2'"
	[[ "${body}" = "$2" ]]	
	test_results=${test_results}$?
	test_number=$((test_number+1))
	return 0
}

test() {
	test_name=$1
	params=$2
	expected_body=$3
	url_to_test="${base_url}${params}"
	echo url_to_test: ${url_to_test}
	
	curl -i -X GET "$url_to_test">${logs_dir}/${test_name}.resp.txt
	
	test_status_is_ok ${logs_dir}/${test_name}.resp.txt
	test_body ${logs_dir}/${test_name}.resp.txt "${expected_body}"
	return 0
}

test test_without_answer_to "" "I'm OK!"
test test_with_empty_answer_to "?answerTo=" "I'm OK!" 
test test_with_answer_to "?answerTo=honey" "I'm OK, honey!"


echo test_results: ${test_results}
test_succeeded=`echo ${test_results}|sed 's/0//g'`
#echo test_succeeded: "${test_succeeded}"

[[ -z "${test_succeeded}" ]] || (echo There are broken tests; exit 1)

