@echo off
echo ================================
echo GitHub Pages 部署脚本
echo ================================
echo.

echo 正在检查必要文件...

REM 检查.nojekyll文件
if not exist ".nojekyll" (
    echo 创建 .nojekyll 文件...
    echo. > .nojekyll
    echo ✅ .nojekyll 文件已创建
) else (
    echo ✅ .nojekyll 文件已存在
)

REM 检查dist目录
if not exist "dist" (
    echo ❌ 错误：dist 目录不存在！
    echo 请先运行 npm run build 构建项目
    pause
    exit /b 1
)

REM 检查关键文件
if not exist "dist\index.html" (
    echo ❌ 错误：dist\index.html 不存在！
    pause
    exit /b 1
)

if not exist "dist\images" (
    echo ❌ 错误：dist\images 目录不存在！
    echo 请确保图片文件夹已正确构建
    pause
    exit /b 1
)

echo ✅ 所有必要文件检查完成
echo.

echo 部署选项：
echo 1. 部署整个项目（推荐）
echo 2. 仅部署 dist 文件夹内容
echo 3. 检查当前文件状态
echo.
set /p choice=请选择部署方式 (1-3): 

if "%choice%"=="1" goto deploy_full
if "%choice%"=="2" goto deploy_dist_only
if "%choice%"=="3" goto check_status
goto invalid_choice

:deploy_full
echo.
echo 📦 准备部署整个项目...
echo.
echo 请按以下步骤操作：
echo.
echo 1. 确保所有文件已提交到 Git：
echo    git add .
echo    git commit -m "Deploy to GitHub Pages"
echo    git push origin main
echo.
echo 2. 在 GitHub 仓库设置中：
echo    - 进入 Settings ^> Pages
echo    - Source: Deploy from a branch
echo    - Branch: main
echo    - Folder: / (root)
echo.
echo 3. 等待几分钟后访问您的 GitHub Pages URL
echo.
goto end

:deploy_dist_only
echo.
echo 📦 准备仅部署 dist 文件夹...
echo.
echo 创建临时部署分支...
if exist "temp_deploy" rmdir /s /q temp_deploy
mkdir temp_deploy
cd temp_deploy

echo 复制 dist 文件夹内容...
xcopy /s /e /y "..\dist\*" "."
if not exist ".nojekyll" echo. > .nojekyll

echo.
echo 请按以下步骤操作：
echo.
echo 1. 初始化新的 Git 仓库：
echo    git init
echo    git add .
echo    git commit -m "Deploy dist to GitHub Pages"
echo.
echo 2. 添加您的 GitHub 仓库作为远程仓库：
echo    git remote add origin https://github.com/您的用户名/您的仓库名.git
echo.
echo 3. 推送到 gh-pages 分支：
echo    git push -f origin main:gh-pages
echo.
echo 4. 在 GitHub 仓库设置中：
echo    - 进入 Settings ^> Pages
echo    - Source: Deploy from a branch
echo    - Branch: gh-pages
echo    - Folder: / (root)
echo.
cd ..
goto end

:check_status
echo.
echo 📋 当前文件状态检查：
echo.
echo 项目根目录文件：
dir /b | findstr /v "node_modules .git temp_deploy"
echo.
echo dist 目录文件：
if exist "dist" (
    dir /b dist
    echo.
    echo dist\images 目录：
    if exist "dist\images" (
        dir /b dist\images
    ) else (
        echo ❌ dist\images 目录不存在
    )
) else (
    echo ❌ dist 目录不存在
)
echo.
goto end

:invalid_choice
echo ❌ 无效选择，请重新运行脚本
goto end

:end
echo.
echo 脚本执行完成！
echo 如需帮助，请查看 GITHUB-PAGES-SETUP.md 文件
echo.
pause