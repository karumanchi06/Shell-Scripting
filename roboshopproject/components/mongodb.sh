#1. Setup MongoDB repos.
#
#```bash
#curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
#```
#
#1. Install Mongo & Start Service.
#
#```bash
## yum install -y mongodb-org
## systemctl enable mongod
## systemctl start mongod
#
#```
#
#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#
#Config file: `/etc/mongod.conf`
#
#then restart the service
#
#```bash
## systemctl restart mongod
#
#```
#
### Every Database needs the schema to be loaded for the application to work.
#
#Download the schema and load it.
#
#```
## curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
#
## cd /tmp
## unzip mongodb.zip
## cd mongodb-main
## mongo < catalogue.js
## mongo < users.js
#
#```
#
#Symbol `<` will take the input from a file and give that input to the command.

source components/common.sh

echo "Download mongodb repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$Log_file

echo "install mongodb"
yum install mongodb-org &>>$Log_file

echo "update mongodb config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$Log_file

echo"start database"
systemctl enable mongod &>>$Log_file
systemctl start mongod &>>$Log_file

echo "download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$Log_file

echo "extract Schema"
cd /tmp
unzip -o mongodb.zip &>>$Log_file


