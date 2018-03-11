#!/bin/bash

# $dbName
# $tname


read -p "Enter your selection pattern: " var1 var2 var3 var4


 case $var1 in 
       all)
           case $var2 in
               where)
                    #check fieldname exits and get its number
                    fnum=$( grep -n "$var3" "$dbName/$tname/$tname.txt"|cut -d :  -f 1 )

                    if [ $fnum ]
                    then
                         echo $fnum
                         lineNum=($(cut -d " " -f $fnum $dbName/$tname/records.txt| grep -n "$var4" |cut -d :  -f 1))
                         for line in ${lineNum[@]}
                         do
                           #print
                           sed -n "$line"p $dbName/$tname/records.txt
                         done 
                    else
                         echo this field name does not exist
                    fi
               ;;
               like)
                    #print
                    sed -n "/$var3/p" $dbName/$tname/records.txt
               ;;
               *)
                 if [ -z $var2 ]
                  then
                       #print
                       cat  $dbName/$tname/records.txt    
                  else
                      echo no such command check your syntax
                  fi
              ;;

           esac
        ;;
        *)
         
             #check fieldname exits and get its number
             fnum=$( grep -n "$var1" "$dbName/$tname/$tname.txt"|cut -d :  -f 1 )

             if [ $fnum ]
             then 
                 if [ -z $var2 ]
                 then
                     #print
                     cut -d " " -f $fnum $dbName/$tname/records.txt
                 elif [ $var2 = "where" ]
                 then
                     #check fieldname exits and get its number
                    fnum1=$( grep -n "$var3" "$dbName/$tname/$tname.txt"|cut -d :  -f 1 )

                    if [ $fnum1 ]
                    then
                         echo $fnum1
                         lineNum=($(cut -d " " -f $fnum1 $dbName/$tname/records.txt| grep -n "$var4" |cut -d :  -f 1))
                         for line in ${lineNum[@]}
                         do
                           #print
                           sed -n "$line"p $dbName/$tname/records.txt|cut -d " " -f $fnum
                         done 
                    else
                         echo this field name does not exist
                    fi

                 fi
             else
                 echo this field does not exist
             fi
        ;;
 esac
