
#```bash
#
## curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
## yum install redis -y
#```
#
#2. Update the BindIP from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`
#
#3. Start Redis Database
#
#```bash
## systemctl enable redis
## systemctl start redis
#```


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





