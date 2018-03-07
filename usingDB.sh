#!bin/bash


echo you are now in $dbName database

createT(){

 check1=$( grep "$1" $dbName.txt )
 # first check if this table already exits
 if [ $check1 ]
 then
      echo this table already exits
 else
  
   #write table name in db file
   echo $1 >> $dbName/$dbName.txt
   #creating neccesary folders and files
   mkdir $dbName/$1
   touch $dbName/$1/$1.txt
   touch $dbName/$1/records.txt
  
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
        check2=$( grep "$name" "$dbName/$1/$1.txt" )#check that field does not already exist

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
   
  echo "$name,$dtype,$pk,$unique,$null,$default" >> "$dbName/$1/$1.txt"
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
  
  check1=$( grep "$1" $dbName/$dbName.txt )
  # first check if this table  exits
  if [ $check1 ]
  then
     rm -r "$dbName/$1"
     sed -i "/$1/d" $dbName/$dbName.txt  
  else
      echo no such table found
  fi  

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
             dropT $var2
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



