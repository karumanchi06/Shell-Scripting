source components/common.sh

echo "configure redis repo"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

echo "install redis"
yum install redis -y &>>$Log_file
if [ $? -eq 0 ];then
  echo -e "\e[1;32m SUCCESS\e[0m"
  else
    echo -e "\e[1;31m FAILED\e[0m"
    exit
    fi

    echo "update redis configuration"
    if [ -f /etc/redis.conf ]; then
      sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>$Log_file
      elif [ /etc/redis/redis.conf ]; then
        sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$Log_file
        fi
        if [ $? -eq 0 ];then
          echo -e "\e[1;32m SUCCESS\e[0m"
          else
            echo -e "\e[1;31m FAILED\e[0m"
            exit
            fi

            echo "start redis"

            systemctl enable redis &>>$Log_file
            systemctl restart redis &>>$Log_file








