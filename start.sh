#!/bin/bash

#set -x

showDB(){
command="databases"
if [ "$1" = $command ]
then
    if [ -s AllDBs.txt ]
    then
        cat AllDBs.txt
    
    else
        echo no databases found
    fi

else
    echo no such command check your syntax!
fi
}

createDB(){

check=$( grep "$2" AllDBs.txt )

   if [ "$1" = "database" ]
   then
       if [ $check ]
       then
           echo this database alreaady exits
       else
           echo $2 >> AllDBs.txt
           mkdir "$2"
           touch "$2/$2.txt"
       fi
        
   else
       echo no such command check your syntax!
   fi
}

useDB(){
 dbName=$1 
 check=$( grep "$dbName" AllDBs.txt )
 if [ $check ]
 then 
      export $dbName
      source  usingDB.sh
      echo you quit $dbName
 else
     echo no such database found
 fi
}

dropDB(){
   check=$( grep "$1" AllDBs.txt )

   if [ $check ]
   then
       rm -r "$1"
       sed -i  "/$1/d" AllDBs.txt
   else
       echo no such database found
   fi
       
}






echo Welcome to your DBMS

while [ true ]
do
read var1 var2 var3

case $var1 in
    show)
       showDB $var2
    ;;
    create)
       createDB $var2 $var3
    ;;
    use)
       useDB $var2
    ;;
    drop)
        dropDB $var2
    ;; 
    exit)
       echo bye bye
       break
    ;;
    *)
      echo no such command
    ;;
esac
done
