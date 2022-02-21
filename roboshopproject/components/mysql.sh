source components/common.sh

echo "setting up MySQL Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$Log_file
if [ $? -eq 0 ];then
    echo -e "\e[1;32m SUCCESS\e[0m"
    else
      echo -e "\e[1;31m FAILED\e[0m"
      exit
      fi

      echo "Install MySQL Server"
      yum install mysql-community-server -y &>>$Log_file
      if [ $? -eq 0 ];then
          echo -e "\e[1;32m SUCCESS\e[0m"
          else
            echo -e "\e[1;31m FAILED\e[0m"
            exit
            fi

      echo "Start MySQL Service"
      systemctl enable mysqld &>>$Log_file
      systemctl start mysqld &>>$Log_file
      if [ $? -eq 0 ];then
          echo -e "\e[1;32m SUCCESS\e[0m"
          else
            echo -e "\e[1;31m FAILED\e[0m"
            exit
            fi

      DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
      echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');
      uninstall plugin validate_password;" >/tmp/pass.sql

      echo "Change Default Password"
      echo 'show databases;' | mysql -uroot -pRoboShop@1 &>>$Log_file
      if [ $? -ne 0 ]; then
        mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$Log_file
      fi
      if [ $? -eq 0 ];then
          echo -e "\e[1;32m SUCCESS\e[0m"
          else
            echo -e "\e[1;31m FAILED\e[0m"
            exit
            fi

      echo "Download MySQL Shipping Schema"
      curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$Log_file
      if [ $? -eq 0 ];then
          echo -e "\e[1;32m SUCCESS\e[0m"
          else
            echo -e "\e[1;31m FAILED\e[0m"
            exit
            fi

      echo "Extract Schema File"
      cd /tmp
      unzip -o mysql.zip &>>$Log_file
      if [ $? -eq 0 ];then
                echo -e "\e[1;32m SUCCESS\e[0m"
                else
                  echo -e "\e[1;31m FAILED\e[0m"
                  exit
                  fi

      echo "Load Schema"
      mysql -uroot -pRoboShop@1 <mysql-main/shipping.sql  &>>$Log_file
      if [ $? -eq 0 ];then
                echo -e "\e[1;32m SUCCESS\e[0m"
                else
                  echo -e "\e[1;31m FAILED\e[0m"
                  exit
                  fi