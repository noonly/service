#! /bin/bash

read -p "在你上次运行之后是否又有变动 [y/n]?" y

if [ "_$y" != "_y" ]; then

	while [ "_$tmp" == "_" ]
	do
		./consul agent --join 192.168.6.110 -config-dir=./conf -data-dir=./data `cat ip 2>/dev/null`
		read -p "Please enter your real IP address (integrant):" ip
		echo "$ip" > ip
	done
	exit 0
fi

defaultpath=`cat ./profile.conf 2>/dev/null` 
if [ "_$defaultpath" == "_" ]; then
	defaultpath="/var/lib/git/";
fi

while [ "_$tmp" == '_' ]
do
        #echo ""
        #echo "invalid container name! please retry!!!"
        read -p "请输入Tomcat工作目录(例如c:\\works,默认$defaultpath): " tmp
        
	if [ "_$tmp" == "_" ]; then
		tmp=$defaultpath
	else
		
		
	
		if [ ! -d "$tmp" ]; then

			echo "invalid path! please retry!!!"
			tmp=""
					
		else
			echo "$tmp" > ./profile.conf
		fi
	fi
	
done
path=$tmp
tmp=""
#if [ -e conf.txt -a ! -s conf.txt ];then echo "empty"; fi
#i=0

for folder in `ls $path`
do
	if [ -d $path"/"$folder"/WebRoot" ]; then
	
		#if [ -f $path"/"$folder"/WebRoot/temp.ctml" ]; then
		#	if [ -f $path"/"$folder"/WebRoot/setvice.json" ]; then
		#		continue
		#	fi
		#fi
		
		#yy="y"
		echo "y" > ./data/.local
		if [ ! -f $path"/"$folder"/WebRoot/service.json" ]; then
			read -p "要把'$folder'项目纳入工程目录吗[y/n]?" yy
			echo $yy > ./data/.local
		else
			
			#echo 'yes="y"' >> $HOME/.profile
			cat ./conf.txt | while read line
			do
				keyword=`echo $line | awk '{print $2}'`
				if [ "_$keyword" != "_" ]; then
					m=`grep $keyword $path"/"$folder"/WebRoot/service.json"`
					if [ "_$m" != "_" ];then
						echo "no" > ./data/.local
					fi
				fi
				
			done
		fi
		yy=`cat ./data/.local 2> /dev/null`
		
		if [ "_$yy" != "_y" ]; then
			continue
		fi
		project=$path"/"$folder"/WebRoot"				
		#projectname=$folder
		while [ "_$pname" == "_" ]
		do
			read -p "请输入'$folder'项目中的有效方法的全路径名 (非常重要，此方法在浏览器中无状态访问返回代码应该是200，例如/Login/web 多个方法直接用空格分隔):" pname
						
		done
		
		for method in $pname
		do
			name=`echo $method | awk -F "/" '{print $2}'`
			#cat ./conf.txt | sed -e '/^$/d' > ./conf.txt
			echo -e "$name $method" >> ./conf.txt
			#echo "{{range service \"$pname\"}}{{if (.Tags.Contains \"$y\")}}ok{{end}}{{end}}" > "$project/temp.ctml"
			echo "{\"service\": {\"name\": \"$name\", \"tags\": [\"web\",\"tomcat\"], \"port\": $port, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$method\",\"interval\":\"30s\"}}}"  > "$project/$name.json"
			echo "{\"service\": {\"name\": \"$name\", \"tags\": [\"web\",\"tomcat\"], \"port\": $port, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$method\",\"interval\":\"30s\"}}}"  > "./conf/$name.json"
		done
		pname=""
		ppath=""
			
		#read -p "$folder is your project[y/n]?" is
		#if [ "_$is" == "_y" ]; then
		#	is=""
			
		#fi
	fi
done

y=""

./project_checks.sh