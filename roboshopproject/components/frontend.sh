
Log_file=/tmp/roboshop.log
rm -f $Log_file

echo "installing nginx"
yum install nginx -y &>>Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi


echo "Download frontend"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "clean old content"
rm -rf /usr/share/nginx/html/* &>>Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo " extract frontend content"
cd /tmp
unzip -o frontend.zip &>>Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "copy extracted content to nginx path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "copy nginx roboshop config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "update roboshop config"
sed -i -e 's/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo"start nginx service"
systemctl enable nginx &>>$Log_file
systemctl start nginx &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

