source components/common.sh

echo "setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$Log_file

echo "install nodejs"
yum install nodejs gcc-c++ -y &>>$Log_file

echo "Create app user"
useradd  roboshop &>>$Log_file

echo "Download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$Log_file

 echo "extract catalogue code"
  cd /tmp/
  unzip -o catalogue.zip &>>$Log_file &>>$Log_file

  echo "clear old catalogue"
  rm -rf /home/roboshop/catalogue

  echo "copy catalogue content"
  cp -r catalogue-main /home/roboshop/catalogue &>>$Log_file

  echo "install NodeJS dependencies"
  cd /home/roboshop/catalogue &>>$Log_file
  npm install &>>Log_file

  chown roboshp:roboshop /home/roboshop/ -g &>>$Log_file

  echo "update systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$Log_file

  echo "setop catalogue systemD File"
  mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$Log_file

  echo "Start Service"
  systemctl daemon-reload catalogue &>>$Log_file
  systemctl enable catalogue &>>$Log_file
  systemctl start catalogue &>>$Log_file








