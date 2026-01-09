@echo off
chcp 65001 >nul
title LLM网页摘要系统 - 一键启动
color 0A

echo LLM网页摘要系统正在启动...

REM 检查Python
python --version >nul 2>nul
if errorlevel 1 (
    echo 错误: 未安装Python
    pause
    exit
)

REM 检查虚拟环境
if not exist "venv\Scripts\activate.bat" (
    echo 正在设置环境...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt >nul 2>nul
    if errorlevel 1 (
        pip install streamlit transformers torch requests beautifulsoup4 readability-lxml Pillow
    )
) else (
    call venv\Scripts\activate.bat
)

REM 启动应用
echo 启动应用中... 浏览器将自动打开
start streamlit run app.py --server.port 8501

pause