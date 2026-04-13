@echo off
setlocal enabledelayedexpansion

echo =============================
echo BUILD + DEPLOY FLUTTER WEB
echo =============================

:: ===== STEP 1 =====
echo.
echo [1] Cleaning project...
flutter clean
if %errorlevel% neq 0 (
    echo ❌ ERROR at step CLEAN
    goto FAIL
)

:: ===== STEP 2 =====
echo.
echo [2] Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ ERROR at step PUB GET
    goto FAIL
)

:: ===== STEP 3 =====
echo.
echo [3] Building web...
flutter build web --release --base-href /tra-loi-atm-pwa/
if %errorlevel% neq 0 (
    echo ❌ ERROR at step BUILD WEB
    goto FAIL
)

:: ===== STEP 4 =====
echo.
echo [4] Removing old docs folder...
rmdir /s /q docs
if exist docs (
    echo ❌ ERROR deleting docs folder
    goto FAIL
)

:: ===== STEP 5 =====
echo.
echo [5] Creating new docs folder...
mkdir docs
if %errorlevel% neq 0 (
    echo ❌ ERROR creating docs folder
    goto FAIL
)

:: ===== STEP 6 =====
echo.
echo [6] Copy build to docs...
xcopy build\web\* docs\ /E /H /C /I /Y >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR copying files
    goto FAIL
)

:: ===== STEP 7 =====
echo.
echo [7] Git add...
git add .
if %errorlevel% neq 0 (
    echo ❌ ERROR git add
    goto FAIL
)

:: ===== STEP 8 =====
echo.
echo [8] Git commit...
git commit -m "deploy update"
if %errorlevel% neq 0 (
    echo ⚠️ Nothing to commit (OK)
)

:: ===== STEP 9 =====
echo.
echo [9] Git push...
git push origin main
if %errorlevel% neq 0 (
    echo ❌ ERROR git push
    goto FAIL
)

:: ===== SUCCESS =====
echo.
echo =============================
echo ✅ DEPLOY SUCCESSFULLY 🚀
echo =============================
pause
exit /b

:: ===== FAIL =====
:FAIL
echo.
echo =============================
echo ❌ DEPLOY FAILED
echo =============================
pause
exit /b