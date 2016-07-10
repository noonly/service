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

i=0
for folder in `ls $path`
do
	if [ -d $path"/"$folder"/WebRoot" ]; then
	
		if [ -f $path"/"$folder"/WebRoot/temp.ctml" ]; then
			if [ -f $path"/"$folder"/WebRoot/setvice.json" ]; then
				continue
			fi
		fi
		read -p "$folder is your project[y/n]?" is
		if [ "_$is" == "_y" ]; then
			is=""
			project=$path"/"$folder"/WebRoot"				
			#projectname=$folder
			while [ "_$pname" == "_" ]
			do
				read -p "Enter your project name (important!!!):" pname
				echo "{{range service \"$pname\"}}{{if (.Tags.Contains \"$y\")}}ok{{end}}{{end}}" > "$project/temp.ctml"
				
			done
			while [ "_$ppath" == "_" ]
			do
				read -p "Enter your project path (important!!! Access this path must return 200 ok. like:/Login/web):" ppath
			done
			#cat ./conf.txt | sed -e '/^$/d' > ./conf.txt
			echo "$pname $ppath" >> ./conf.txt
			echo "{\"service\": {\"name\": \"$pname\", \"tags\": [\"web\",\"slave\"], \"port\": $port, \"check\":{\"name\":\"status\",\"http\":\"http://localhost:8080$ppath\",\"interval\":\"30s\"}}}"  > "$project/setvice.json"
			pname=""
			ppath=""
			i=$(($i+1))
		fi
	fi
done

y=""

./project_checks.sh