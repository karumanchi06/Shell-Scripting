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

echo "Download cart code"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

 echo "extract cart code"
  cd /tmp/
  unzip -o cart.zip &>>$Log_file &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "clear old cart"
  rm -rf /home/roboshop/cart
  if [ $? -eq 0 ];then
      echo -e "\e[1;32m SUCCESS\e[0m"
      else
        echo -e "\e[1;31m FAILED\e[0m"
        exit
        fi

  echo "copy cart content"
  cp -r cart-main /home/roboshop/cart &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "install NodeJS dependencies"
  cd /home/roboshop/cart &>>$Log_file
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

  echo "Update systemD file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e  's/MONGO_ENDPOINT/mongodb.roboshop.internal/'  /home/roboshop/cart/systemd.service &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "setup cart systemD File"
  mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

  echo "Start Service"
  systemctl daemon-reload cart &>>$Log_file
  systemctl enable cart &>>$Log_file
  systemctl start cart &>>$Log_file
  if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi








