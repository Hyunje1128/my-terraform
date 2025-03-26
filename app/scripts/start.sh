#!/bin/bash

APP_DIR="/home/ec2-user/app"
LOG_FILE="$APP_DIR/app.log"

echo "[INFO] Starting static web serveron port 80..." | tee -a "$LOG_FILE"

# Python을 이용한 간단한 정적 서버 실행 (port 80)
cd $APP_DIR

# 백그라운드 실행
nohup python3 -m http.server 80 > "$LOG_FILE" 2>&1 &
echo "[INFO] Static server started on port 8080" >> "$LOG_FILE"