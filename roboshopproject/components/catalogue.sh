source components/common.sh

echo "setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$Log_file
if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

echo "install nodejs"
yum install nodejs gcc-c++ -y &>>$Log_file
if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

echo "Create app user"
id roboshop &>>$Log_file
if [ $? -ne 0 ]; then
useradd  roboshop &>>$Log_file
fi


echo "Download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$Log_file
if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

 echo "extract catalogue code"
  cd /tmp/
  unzip -o catalogue.zip &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "clear old catalogue"
  rm -rf /home/roboshop/catalogue

  echo "copy catalogue content"
  cp -r catalogue-main /home/roboshop/catalogue &>>$Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "install NodeJS dependencies"
  cd /home/roboshop/catalogue &>>$Log_file
  npm install &>>Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  chown roboshop:roboshop /home/roboshop/ -R &>>$Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "update systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "setop catalogue systemD File"
  mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "Start Service"
  systemctl daemon-reload catalogue &>>$Log_file
  systemctl enable catalogue &>>$Log_file
  systemctl start catalogue &>>$Log_file
if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi







