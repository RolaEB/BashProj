#!bin/bash


echo you are now in $dbName database

createT(){
  echo $1
}

insertR(){
  echo insert

}

editR(){
  echo edit

}

selectR(){
  echo select
}

show(){
  echo show
}

sortT(){
 echo sort
}

dropT(){
 echo drop
}

descT(){
  echo describe
}

alterT(){
   echo alter table
}

while [ true ]
do
  read var1 var2 
  case $var1 in
       create)
             createT $var2
        ;;
       insert)
             insertR
        ;;
        edit)
             editR
        ;;
        select)
             selectR
        ;;
        show)
              show
        ;;
        sort)
             sortT
        ;;
        drop)
             dropT
        ;;
        desc)
            descT
        ;;
        alter)
             alterT
        ;;
        exit)
             echo exit
             break
        ;;
        *)
          echo no such command found check your syntax!
        ;;
 esac
done



