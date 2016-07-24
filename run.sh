#! /bin/bash

read -p "在你上次运行之后是否又有变动 [y/n]?" -e y

if [ "_$y" != "_y" ]; then

	while [ "_$tmp" == "_" ]
	do
		./consul agent --join 192.168.6.110 -config-dir=./conf -data-dir=./data `cat ip 2>/dev/null`
		read -p "Please enter your real IP address (integrant):" -e ip
		echo "$ip" > ip
	done
	exit 0
	
#else
#rm -f ./conf/*
#rm -f ./conf/.json
#rm -f ./conf.txt
fi


defaultpath=`cat ./profile.conf 2>/dev/null` 
if [ "_$defaultpath" == "_" ]; then
	defaultpath="/var/lib/git/";
fi

while [ "_$tmp" == '_' ]
do
        #echo ""
        #echo "invalid container name! please retry!!!"
        read -p "请输入Tomcat工作目录(例如c:\\works,默认$defaultpath): " -e tmp
        
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
		if [ ! -f $path"/"$folder"/WebRoot/service.conf" ]; then
			read -p "要把'$folder'项目纳入工程目录吗[y/n]?" -e yy
			#echo $yy > ./data/.local
		else
			echo "$folder project includes the following content:"
			for p in `cat $path"/"$folder"/WebRoot/service.conf"`
			do 
				echo $p
			done
			yy=n
			read -p "Do you want to update profile[(c)lean/(a)ppend/(n)o]?" -e yy
			
			if [ "_$yy" == "_c" ]; then
				echo "" >  $path"/"$folder"/WebRoot/service.conf"
				rm -rf $path"/"$folder"/WebRoot/*.json"
			fi
			if [ "_$yy" != "_n" ]; then
				yy=y
			fi
			
			if [ ]; then
			#echo 'yes="y"' >> $HOME/.profile
			for json in `ls $path"/"$folder"/WebRoot/*.json"`
			do
				cat $json | while read line
				do
					keyword=`echo $line | awk '{print $2}'`
					if [ "_$keyword" != "_" ]; then
						m=`grep $keyword $path"/"$folder"/WebRoot/service.conf"`
						if [ "_$m" != "_" ];then
							echo "no" > ./data/.local
						fi
					fi
					
				done
			done
			fi
		fi
		#yy=`cat ./data/.local 2> /dev/null`
		
		if [ "_$yy" != "_y" ]; then
			continue
		fi
		project=$path"/"$folder"/WebRoot"				
		#projectname=$folder
		while [ "_$pname" == "_" ]
		do
			read -p "Please input methods full path within '$folder' project (like /Login/web.):" -e pname
			echo "$pname"  > "$project/service.conf"			
		done
		
		for method in $pname
		do
			name=`echo $method | awk -F "/" '{print $2}'`
			#cat ./conf.txt | sed -e '/^$/d' > ./conf.txt
			echo -e "$name $method" >> ./conf.txt
			#echo "{{range service \"$pname\"}}{{if (.Tags.Contains \"$y\")}}ok{{end}}{{end}}" > "$project/temp.ctml"
			echo "{\"service\": {\"name\": \"$name\", \"tags\": [\"web\",\"tomcat\"], \"port\": 8080, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$method\",\"interval\":\"30s\"}}}"  > "$project/$name.json"
			echo "{\"service\": {\"name\": \"$name\", \"tags\": [\"web\",\"tomcat\"], \"port\": 8080, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$method\",\"interval\":\"30s\"}}}"  > "./conf/$name.json"
			
 		done
		
		if [ -d $path"/"$folder"/.git" ]; then 
			PWD=`pwd`
			cd $path"/"$folder
			rm -rf `find ./ -name ".gitignore"`
			git add .
			git commit -m "`date`"
			git push origin master
			cd $PWD
		fi
		
			
		pname=""
		ppath=""
			
		#read -p "$folder is your project[y/n]?" is
		#if [ "_$is" == "_y" ]; then
		#	is=""
			
		#fi
	fi
done

y=""

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