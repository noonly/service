#! /bin/bash
url="http://localhost"
port="8080"
ip=""
pwd=`pwd`
#project="/Login/web"
i=0
tmp=""
#read -p "Please enter your tomcat port (default:8080):" tmp
#if [ "_$tmp" != "_" ]; then
#	port=$tmp
#fi
#tmp=""
read -p "Please enter your IP address (If your computer has multiple network cards):" tmp

if [ "_$tmp" != "_" ]; then
	ip=$tmp
fi
tmp=""


IFS=$'\n'
echo "" | tee -a ./conf.txt
y="y"
read -p "Auto settings profiles[y/n]?" y

if [ "_$y" == "_y" ]; then
rm -rf ./conf/*
cat ./conf.txt | while read line
do

	
	
	path=`echo $line | awk '{print $1}'`
	p=`echo $line | awk '{print $2}'`
	if [ "_$path" == "_" ]; then
		continue
	fi
	
	echo "#! /bin/bash" > ./conf/$path".sh"
	echo 'code=`curl -o /dev/null -s -w %{http_code} '$url":"$port$p'`' >> ./conf/$path".sh"
	echo "if [ \"_\$code\" == \"_200\"  ]; then">>./conf/$path".sh"
	echo "exit 0">>./conf/$path".sh"
	#echo "elif [ \"_\$code\" == \"_400\" ]; then">>./conf/$path".sh"
	#echo "exit 0">>./conf/$path".sh"
	echo "else">>./conf/$path".sh"
	echo "exit 2">>./conf/$path".sh"
	echo "fi">>./conf/$path".sh"
	#script=`awk '{print $}' conf.txt`
	echo "{\"service\": {\"name\": \"$path\", \"tags\": [\"web\",\"master\"], \"port\": $port, \"check\":{\"name\":\"status\",\"http\":\"$url:$port$p\",\"interval\":\"30s\"}}}" > ./conf/$path".json"
	echo "$i-$path"
	
	chmod 755 ./conf/$path".sh"
	i=$(($i+1))
done
fi
error=""
tmp=""

while [ "_$tmp" == "_" ]
do
	if [ "_$ip" != "_" ]; then
		echo "--bind $ip" > ip
		./consul agent --join 192.168.6.110 -config-dir=./conf -data-dir=./data --bind $ip 
	else
		./consul agent --join 192.168.6.110 -config-dir=./conf -data-dir=./data
	fi

	read -p "Please enter your real IP address (integrant):" ip
	

done
#code=`curl -o /dev/null -s -w %{http_code} http://localhost:8080/Auth/`
#if [ "_$code" == "_200"  ]; then
#exit 0
#elif [ "_$code" == "_400" ]; then
#exit 0
#else
#exit 2
#fi