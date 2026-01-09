@echo off
chcp 65001 >nul
title LLM网页摘要系统 - 初始设置向导
color 0B

echo ============================================
echo    🔧 LLM网页摘要系统 - 初始设置
echo ============================================
echo.

:check_python
echo [步骤1/4] 检查Python环境...
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] Python未安装或未添加到PATH
    echo.
    echo 解决方案:
    echo 1. 安装Python 3.8+
    echo 2. 安装时勾选"Add Python to PATH"
    echo 3. 或手动添加Python到系统PATH
    echo.
    pause
    goto :check_python
)

python --version
echo [成功] Python检测正常
echo.

:create_venv
echo [步骤2/4] 创建虚拟环境...
if exist "venv" (
    choice /M "虚拟环境已存在，是否重新创建"
    if %errorlevel% equ 1 (
        rmdir /s /q venv
        python -m venv venv
    )
) else (
    python -m venv venv
)

if not exist "venv\Scripts\activate.bat" (
    echo [错误] 虚拟环境创建失败
    pause
    goto :create_venv
)
echo [成功] 虚拟环境创建完成
echo.

:install_deps
echo [步骤3/4] 安装依赖...
call venv\Scripts\activate.bat

echo [信息] 正在安装依赖，可能需要几分钟...
echo [提示] 首次安装transformers会下载约1.5GB模型文件
echo.

pip install --upgrade pip
pip install streamlit transformers torch
pip install requests beautifulsoup4 readability-lxml
pip install Pillow pytesseract pdf2image

echo.
echo [成功] 依赖安装完成
echo.

:final_setup
echo [步骤4/4] 最终设置...
echo.

REM 创建默认配置文件
if not exist "user_config.ini" (
    echo [创建] 用户配置文件
    (
        echo [DEFAULT]
        echo model_path = %USERPROFILE%\.cache\web_summarizer\models
        echo cache_dir = %USERPROFILE%\.cache\web_summarizer
        echo timeout = 30
        echo language = zh
    ) > user_config.ini
)

echo [设置] 模型缓存路径
set TRANSFORMERS_CACHE=%USERPROFILE%\.cache\web_summarizer
set HF_HOME=%USERPROFILE%\.cache\web_summarizer

if not exist "%TRANSFORMERS_CACHE%" (
    mkdir "%TRANSFORMERS_CACHE%"
)

echo.
echo ============================================
echo    ✅ 初始设置完成！
echo ============================================
echo.
echo 使用说明:
echo 1. 运行 run.bat 启动系统
echo 2. 浏览器会自动打开 http://localhost:8501
echo 3. 首次运行需要下载模型，请保持网络畅通
echo.
echo [重要] 如需OCR功能:
echo 请安装 Tesseract-OCR: https://github.com/UB-Mannheim/tesseract/wiki
echo 安装后，将tesseract.exe所在目录添加到系统PATH
echo.

pause
exit /b 0