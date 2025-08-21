@echo off
REM #################################################
REM # Script de lancement du serveur web EVA
REM # AMPERE SOFTWARE TECHNOLOGY - RENAULT
REM #################################################

echo ================================================
echo        LANCEMENT SERVEUR WEB EVA
echo      AMPERE SOFTWARE TECHNOLOGY - RENAULT      
echo ================================================
echo.

REM Vérifier si Python est disponible
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python n'est pas installe ou pas dans le PATH.
    echo        Veuillez d'abord executer install.bat
    pause
    exit /b 1
)

REM Vérifier si Flask est installé
python -c "import flask" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flask n'est pas installe.
    echo        Veuillez d'abord executer install.bat
    pause
    exit /b 1
)

REM Vérifier si app.py existe
if not exist app.py (
    echo ERROR: app.py introuvable.
    echo        Assurez-vous d'etre dans le bon repertoire.
    pause
    exit /b 1
)

echo OK Toutes les verifications sont passees
echo.
echo ================================================
echo              LANCEMENT DU SERVEUR
echo ================================================
echo.
echo Le serveur web va demarrer...
echo.
echo Ouvrez votre navigateur et allez sur :
echo    http://localhost:5000
echo.
echo Pour arreter le serveur : Appuyez sur Ctrl+C
echo.
echo ================================================
echo.

REM Lancer le serveur
python app.py

pause
