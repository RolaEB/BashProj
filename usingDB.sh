#!bin/bash


echo you are now in $dbName database

createT(){

 check1=$( grep "$1" $dbName.txt )

 if [ $check1 ]
 then
      echo this table already exits
 else


while [ true ]
do
  echo do you want to add a field to this table?Y/N
  read var
  if [ $var = "Y" ]
  then
      while [ true ]
      do   
        echo enter field name
        read name
        check2=$( grep "$name" "$1.txt" )

        if [ $check2 ]
        then
           echo this filed already exists
        else
             break
        fi
       done

  echo enter datatype
  read dtype 
  echo enter PK restriction 1 for true 0 for false
  read pk
  
  echo Is this field unique? 1/0
  read unique
  echo Can this field be Null? 1/0
  read null
  echo Does this field has a default value? or None?
  read default
   
  echo "$name,$dtype,$pk,$unique,$null,$default" >> "$1.txt"
  else
      break
  fi

done
fi
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



