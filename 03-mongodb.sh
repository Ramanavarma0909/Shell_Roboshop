
#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/mongodb.log"

R="\e[31m"
G="\e[32m"
N="\e[0m"

mkdir -p "$LOGS_FOLDER"

if [ "$USERID" -ne 0 ]; then
    echo -e "${R}Please run this command with root access${N}"
    exit 1
fi

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo -e "${R}$2...failure${N}" | tee -a "$LOGS_FILE"
        exit 1
    else
        echo -e "${G}$2...success${N}" | tee -a "$LOGS_FILE"
    fi
}

if [ ! -f mongo.repo ]; then
    echo "ERROR: mongo.repo not found in $(pwd)"
    exit 1
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo >> "$LOGS_FILE" 2>&1
VALIDATE $? "Copying mongo.repo"

dnf clean all >> "$LOGS_FILE" 2>&1
dnf makecache >> "$LOGS_FILE" 2>&1
dnf install mongodb-org -y >> "$LOGS_FILE" 2>&1
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod >> "$LOGS_FILE" 2>&1
VALIDATE $? "Enabling MongoDB service"

systemctl start mongod >> "$LOGS_FILE" 2>&1
VALIDATE $? "Starting MongoDB service"

echo "MongoDB installation and startup completed."
