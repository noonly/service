#! /bin/bash
read -p "Are you master node [y/n]?" y
if [ "_$y" == "_y" ]; then
	y="master"
else
	y="slave"
fi
defaultpath=`cat ./profile.conf 2>/dev/null` 
if [ "_$defaultpath" == "_" ]; then
	defaultpath="/var/lib/git/";
fi

while [ "_$tmp" == '_' ]
do
        #echo ""
        #echo "invalid container name! please retry!!!"
        read -p "Please settings tomcat webapps path (etc. $defaultpath): " tmp
        
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
		if [ ! -f $path"/"$folder"/WebRoot/temp.ctml" ] || [ ! -f $path"/"$folder"/WebRoot/service.json" ]; then
			read -p "The path '$folder' is your project[y/n]?" yy
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
			read -p "Enter your '$folder' project name (important!!!):" pname
			echo "{{range service \"$pname\"}}{{if (.Tags.Contains \"$y\")}}ok{{end}}{{end}}" > "$project/temp.ctml"
			
		done
		while [ "_$ppath" == "_" ]
		do
			read -p "Enter your '$folder' project path (important!!! Access this path must return 200 ok. like:/Login/web):" ppath
		done
		#cat ./conf.txt | sed -e '/^$/d' > ./conf.txt
		echo -e "$pname $ppath" >> ./conf.txt
		echo "{\"service\": {\"name\": \"$pname\", \"tags\": [\"web\",\"slave\"], \"port\": $port, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$ppath\",\"interval\":\"30s\"}}}"  > "$project/service.json"
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