#!/bin/bash



# $dbName
# $tname



 read -p "Enter your update: " var1 var2 var3 

  fnum=$( grep -n "$var2" "$dbName/$tname/$tname.txt"|cut -d :  -f 1 )
  
  if [ $fnum ] #check if fieldname exists
  then

      case $var1 in 

        set)
          cat $dbName/$tname/records.txt | awk  '{ $'"$fnum"' ="'"$var3"'"; print}' > /tmp/output.txt
          cat /tmp/output.txt > $dbName/$tname/records.txt
          
          ;;
        delete)
             lineNum=($(cut -d " " -f $fnum $dbName/$tname/records.txt| grep -n "$var3" |cut -d :  -f 1))
           
             sed -i  ''"$lineNum"'d' $dbName/$tname/records.txt 
             
          ;;
        *)
          echo command not found
          ;;
       esac

  else 
      echo fieldname does not exist

  fi
