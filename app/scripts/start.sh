#!/bin/bash

APP_DIR="/home/ec2-user/app"
JAR_NAME=$(ls $APP_DIR/*.jar | head -n 1)

echo "[INFO] Starting application..."

cd $APP_DIR

# 백그라운드 실행
nohup java -jar $JAR_NAME > app.log 2>&1 &
echo "[INFO] Application started with PID $!" >> app.log
