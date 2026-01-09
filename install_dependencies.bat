@echo off
chcp 65001 >nul
title LLM网页摘要系统 - 依赖安装
color 0E

echo ============================================
echo    📦 LLM网页摘要系统 - 依赖安装
echo ============================================
echo.
echo [信息] 正在安装项目依赖...
echo.

REM 激活虚拟环境
if exist "venv" (
    call venv\Scripts\activate.bat
)

REM 升级pip
echo [1/6] 升级pip...
python -m pip install --upgrade pip

REM 安装核心依赖
echo [2/6] 安装核心依赖...
pip install streamlit transformers torch

REM 安装网页处理依赖
echo [3/6] 安装网页处理依赖...
pip install requests beautifulsoup4 readability-lxml

REM 安装OCR相关依赖
echo [4/6] 安装OCR相关依赖...
pip install Pillow pytesseract pdf2image

REM 安装其他工具
echo [5/6] 安装其他工具...
pip install pandas numpy

REM 生成requirements.txt
echo [6/6] 生成依赖清单...
pip freeze > requirements.txt

echo.
echo ============================================
echo    ✅ 依赖安装完成！
echo ============================================
echo.
echo [提示] 如果需要手动安装Tesseract OCR:
echo     1. 下载: https://github.com/UB-Mannheim/tesseract/wiki
echo     2. 安装后，将安装路径添加到系统PATH
echo     3. 或者修改config.py，将pytesseract路径指向安装位置
echo.

pause
exit /b 0