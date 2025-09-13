#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE() {
if [ $1 -ne 0 ]
   then
      echo -e "$2... $R FAILURE $N"
      exit 1
   else
      echo -e "$2... $G SUCCESS $N"
   fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "ERROR:: you must have sudo access to execute this script"
        exit 1 #other than 0
    fi
}

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $TIMESTAMP" &>>$LOGS_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>$LOGS_FILE_NAME
VALIDATE $? "Installing MYSQL Server"

systemctl enable mysqld &>>$LOGS_FILE_NAME
VALIDATE $? "Enabling MYSQL Server"

systemctl start mysqld &>>$LOGS_FILE_NAME
VALIDATE $? "Starting MYSQL Server"

mysql -h mysql.daws-82s.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOGS_FILE_NAME

if [ $? -ne 0 ]
then
  echo "MYSQL Root Password not setup" &>>$LOGS_FILE_NAME
  mysql_secure_installation --set-root-pass ExpenseApp@1
  VALIDATE $? "Setting Root Password"
else
  echo -e "MYSQl Root Password already setup... $Y SKIPPING $N"
fi










   



  