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

if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "Download user code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

 echo "extract user code"
  cd /tmp/
  unzip -o user.zip &>>$Log_file &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "clear old user"
  rm -rf /home/roboshop/user
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "copy user content"
  cp -r user-main /home/roboshop/user &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "install NodeJS dependencies"
  cd /home/roboshop/user &>>$Log_file
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

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
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "setop user systemD File"
  mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "Start Service"
  systemctl daemon-reload user &>>$Log_file
  systemctl enable user &>>$Log_file
  systemctl start user &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi








