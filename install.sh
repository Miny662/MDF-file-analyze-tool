#!/bin/bash
#################################################
# Script d'installation EVA Report Generator
# AMPERE SOFTWARE TECHNOLOGY - RENAULT
#################################################

echo "================================================"
echo "     INSTALLATION EVA REPORT GENERATOR         "
echo "     AMPERE SOFTWARE TECHNOLOGY - RENAULT      "
echo "================================================"
echo ""

# Vérifier Python
echo "🔍 Vérification de Python..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé. Veuillez installer Python 3.8 ou supérieur."
    echo "   Téléchargement : https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✅ Python $PYTHON_VERSION détecté"

# Vérifier pip
echo "🔍 Vérification de pip..."
if ! command -v pip3 &> /dev/null; then
    echo "⚠️  pip n'est pas installé. Installation..."
    python3 -m ensurepip --default-pip
fi
echo "✅ pip disponible"

# Créer environnement virtuel (optionnel mais recommandé)
echo ""
read -p "📦 Créer un environnement virtuel ? (recommandé) [O/n] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "🔧 Création de l'environnement virtuel..."
    python3 -m venv venv_eva
    source venv_eva/bin/activate
    echo "✅ Environnement virtuel créé et activé"
fi

# Installer les dépendances
echo ""
echo "📦 Installation des dépendances..."
pip3 install --upgrade pip
pip3 install -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✅ Dépendances installées avec succès"
else
    echo "❌ Erreur lors de l'installation des dépendances"
    exit 1
fi

# Créer le dossier de sortie
echo "📁 Création du dossier de sortie..."
mkdir -p eva_reports
echo "✅ Dossier eva_reports créé"

# Vérifier l'installation
echo ""
echo "🔍 Vérification de l'installation..."
python3 -c "import asammdf, docx, matplotlib, pandas; print('✅ Tous les modules sont installés correctement')"

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "      ✅ INSTALLATION TERMINÉE AVEC SUCCÈS     "
    echo "================================================"
    echo ""
    echo "📖 Pour utiliser le générateur :"
    echo "   python3 generate_eva_report_exact_template.py --help"
    echo ""
    echo "📊 Exemple :"
    echo "   python3 generate_eva_report_exact_template.py \\"
    echo "     --mdf tina/Roulage.mdf \\"
    echo "     --sweet 400 \\"
    echo "     --myfx all"
    echo ""
    if [ -d "venv_eva" ]; then
        echo "⚠️  N'oubliez pas d'activer l'environnement virtuel :"
        echo "   source venv_eva/bin/activate"
    fi
    echo ""
else
    echo "❌ Erreur lors de la vérification de l'installation"
    exit 1
fi