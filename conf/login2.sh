#! /bin/bash
code=`curl -o /dev/null -s -w %{http_code} http://localhost:8080/AccessInterface/isAuth`
if [ "_$code" == "_200"  ]; then
exit 0
else
exit 2
fi
