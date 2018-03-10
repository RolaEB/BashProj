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
   elif [ "$datatype" = "string" ]
   then
       re='^[a-zA-Z]+$'
      if ! [[ $input =~ $re ]] ; then
           echo error:$input is Not a string
           return 1
       fi

   fi
}

checkPK(){
  echo hello
} 

checkNull(){
  input=$1
  NullAllow=$2
  if [ "$NullAllow" = "0" ]
  then 
      if [ "$input" = "0" ]
      then 
          echo Value can Not be null
          return 1
      fi

  fi


}
checkUnique(){
  input=$1
  isUnique=$2
  tname=$3
  if [ $isUnique =  "1" ]
  then
      check=$( grep "$input" $dbName/$tname/records.txt )
      if [ ! -z "$check" ]
      then
          echo Value must be unique
          return 1
      fi
 

  fi
}

checkDefault(){
   input=$1
   default=$2

   if [ $input = "default" ]
   then
       if [ $default = "none" ]
       then
           echo Field has no default
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
      output=()
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
          tf=$?
          echo $tf
          #checkPK $i $( cut -d',' -f3 /tmp/restr.txt )

          checkUnique $i $( cut -d',' -f4 /tmp/restr.txt ) $1
          uf=$?
          echo $uf

          checkNull $i $( cut -d',' -f5 /tmp/restr.txt ) 
          nf=$?
          echo $nf
         
    
          checkDefault $i $( cut -d',' -f6 /tmp/restr.txt )
          df=$?
          echo $df
          let "counter++"
          # check if all restrictions are met write it in array
            let checkflags=$tf+$uf+$nf+$df
            echo $checkflags
            if [ $checkflags -eq 0 ]
            then
                output=(${output[@]} $i)
            fi    
          done
          if [ ${#output[@]} -eq $numfields ]
          then
              echo ${output[@]} >> $dbName/$1/records.txt
          fi
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
  
  check1=$( grep "$1" $dbName/$dbName.txt )
  # first check if this table  exits
  if [ $check1 ]
  then
      if [ -s $dbName/$1/records.txt ]
      then
          cat $dbName/$1/records.txt
      else
          echo No records found for this table
      fi
  else
      echo table does not exist
  fi


  
}

sortT(){

  check1=$( grep "$1" "$dbName/$dbName.txt" )
  # check if table exists
  if [ $check1 ]
  then 
      case $2 in
          asc)
              sort $dbName/$1/records.txt
          ;;
          desc)
              sort -r $dbName/$1/records.txt
          ;;
          *)
             echo command not found check your syntax
         ;; 
     esac
  else
     echo table does not exist
  fi
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
     echo "Field Name  Type  PK  Null  Unique Default "
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
  read var1 var2 var3
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
              show $var2
        ;;
        sort)
             sortT $var2 $var3
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
  

esac

done
