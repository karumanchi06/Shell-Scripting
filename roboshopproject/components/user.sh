source components/common.sh

echo "setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$Log_file

echo "install nodejs"
yum install nodejs gcc-c++ -y &>>$Log_file

echo "Create app user"
useradd  roboshop &>>$Log_file

echo "Download user code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$Log_file

 echo "extract user code"
  cd /tmp/
  unzip -o user.zip &>>$Log_file &>>$Log_file

  echo "clear old user"
  rm -rf /home/roboshop/user

  echo "copy user content"
  cp -r user-main /home/roboshop/user &>>$Log_file

  echo "install NodeJS dependencies"
  cd /home/roboshop/user &>>$Log_file
  npm install &>>Log_file

  chown roboshp:roboshop /home/roboshop/ -g &>>$Log_file

  echo "update systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>$Log_file

  echo "setop user systemD File"
  mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$Log_file

  echo "Start Service"
  systemctl daemon-reload user &>>$Log_file
  systemctl enable user &>>$Log_file
  systemctl start user &>>$Log_file








