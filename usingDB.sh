#!bin/bash


echo you are now in $dbName database

createT(){

 check1=$( grep "$1" $dbName/$dbName.txt )
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

# checker functions

checkType(){
   input=$1
   datatype=$2
   if [ "$datatype" = "num" ]
   then
      re='^[0-9]+$'
      if ! [[ $input =~ $re ]] ; then
           echo error:$input is Not a number
           return 1
       fi
   elif [ $datatype='string' ]
   then
       re='^[a-zA-Z]+$'
      if ! [[ $input =~ $re ]] ; then
           echo error:$input is Not a string
           return 1
       fi

   fi
}

insertR(){
  #check table exists
  check1=$( grep "$1" "$dbName/$dbName.txt" )

  if [ $check1 ]
  then
      #count number of fields in table
      numfields=$(cat $dbName/$1/$1.txt |wc -l)
      counter=1
      echo Enter your record:
      read -a record
      if [ $numfields -eq ${#record[@]} ]
      then
          
          for i in ${record[@]}
          do
          # get restrictions of field
          awk "NR==$counter" $dbName/$1/$1.txt > /tmp/restr.txt
          cat  /tmp/restr.txt
          #cut -d',' -f1 /tmp/restr.txt
          
          
          checkType $i $( cut -d',' -f2 /tmp/restr.txt )
          #checkPK $i $( cut -d',' -f3 /tmp/restr.txt )
          #checkNull $i $( cut -d',' -f4 /tmp/restr.txt )
          #checkUnique $i $( cut -d',' -f5 /tmp/restr.txt )
          #checkDefault $i $( cut -d',' -f6 /tmp/restr.txt )
          let "counter++"
          
          done
      else
         echo Error,check your syntax!
      fi

  else 
    echo Table does not exist
  fi
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
  check1=$( grep "$1" $dbName/$dbName.txt )
  # first check if this table  exits
  if [ $check1 ]
  then
     echo $1
     echo "Field Name  Type  PK  Null  Unique Default  "
     awk 'BEGIN {FS=","}{print "Name: "$1;print "Datatype: "$2;print "PK: "$3;print "Null: "$4;print "Unique: "$5;print "Default: "$6}' $dbName/$1/$1.txt

     
  else
      echo no such table found
  fi

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
             insertR $var2
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
            descT $var2
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



