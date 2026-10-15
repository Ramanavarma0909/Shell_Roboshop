#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "${R}Plesae run this command with root user access${N}" | tee -a $LOGS_FILE
    exit 1
fi

   mkdir -p $LOGS_FOLDER

 VALIDATE(){
    if [ $1 -ne 0 ]; then
           echo "$2...$Rfailure ${N}" | tee -a $LOGS_FILE
           exit 1
       else
           echo "$2...$Gsuccess ${N}" | tee -a $LOGS_FILE
    fi
 }

    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
    VALIDATE $? "copying mongo.repo"

    dnf install mongodb-org -y
    VALIDATE $? "installing mongodb server"

    systemctl enable mongod
    VALIDATE $? "enabling mongodb service"

    systemctl start mongod
    VALIDATE $? "starting mongodb service"

    sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
    VALIDATE $? "updating mongodb config file"

    systemctl restart mongod
    VALIDATE $? "restarting mongodb service"