@echo off
REM #################################################
REM # Script d'installation EVA Report Generator
REM # AMPERE SOFTWARE TECHNOLOGY - RENAULT
REM #################################################

echo ================================================
echo      INSTALLATION EVA REPORT GENERATOR         
echo      AMPERE SOFTWARE TECHNOLOGY - RENAULT      
echo ================================================
echo.

REM Vérifier Python
echo Verification de Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python n'est pas installe. Veuillez installer Python 3.8 ou superieur.
    echo        Telechargement : https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo OK Python %PYTHON_VERSION% detecte

REM Vérifier pip
echo Verification de pip...
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ATTENTION: pip n'est pas installe. Installation...
    python -m ensurepip --default-pip
)
echo OK pip disponible

REM Créer environnement virtuel (optionnel)
echo.
set /p CREATE_VENV="Creer un environnement virtuel ? (recommande) [O/n] "
if /i "%CREATE_VENV%" neq "n" (
    echo Creation de l'environnement virtuel...
    python -m venv venv_eva
    call venv_eva\Scripts\activate.bat
    echo OK Environnement virtuel cree et active
)

REM Installer les dépendances
echo.
echo Installation des dependances...
pip install --upgrade pip
pip install -r requirements.txt

if %errorlevel% equ 0 (
    echo OK Dependances installees avec succes
) else (
    echo ERREUR lors de l'installation des dependances
    pause
    exit /b 1
)

REM Créer le dossier de sortie
echo Creation du dossier de sortie...
if not exist eva_reports mkdir eva_reports
echo OK Dossier eva_reports cree

REM Vérifier l'installation
echo.
echo Verification de l'installation...
python -c "import asammdf, docx, matplotlib, pandas; print('OK Tous les modules sont installes correctement')"

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo       INSTALLATION TERMINEE AVEC SUCCES     
    echo ================================================
    echo.
    echo Pour utiliser le generateur :
    echo    python generate_eva_report_exact_template.py --help
    echo.
    echo Exemple :
    echo    python generate_eva_report_exact_template.py ^
    echo      --mdf tina\Roulage.mdf ^
    echo      --sweet 400 ^
    echo      --myfx all
    echo.
    if exist venv_eva (
        echo N'oubliez pas d'activer l'environnement virtuel :
        echo    venv_eva\Scripts\activate.bat
    )
    echo.
) else (
    echo ERREUR lors de la verification de l'installation
    pause
    exit /b 1
)

pause