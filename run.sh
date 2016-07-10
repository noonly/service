#! /bin/bash
read -p "Are you master node [y/n]?" y
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
			continue
		fi
		read -p "$folder is your project[y/n]?" is
		if [ "_$is" == "_y" ]; then
			is=""
			project=$path"/"$folder"/WebRoot"				
			#projectname=$folder
			while [ "_$pname" == "_" ]
			do
				read -p "Enter your project name (important!!!):" pname
				echo "{{range service \"$pname\"}}{{if (.Tags.Contains \"master\")}}ok{{end}}{{end}}" > "$project/temp.ctml"
			done
			while [ "_$ppath" == "_" ]
			do
				read -p "Enter your project path (important!!! Access this path must return 200 ok):" ppath
			done
			#cat ./conf.txt | sed -e '/^$/d' > ./conf.txt
			echo "$pname $ppath" >> ./conf.txt
			pname=""
			ppath=""
			i=$(($i+1))
		fi
	fi
done

./project_checks.sh