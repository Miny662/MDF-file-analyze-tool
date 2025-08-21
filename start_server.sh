#!/bin/bash
#################################################
# Script de lancement du serveur web EVA
# AMPERE SOFTWARE TECHNOLOGY - RENAULT
#################################################

echo "================================================"
echo "        🚀 LANCEMENT SERVEUR WEB EVA"
echo "      AMPERE SOFTWARE TECHNOLOGY - RENAULT      "
echo "================================================"
echo ""

# Vérifier si Python est disponible
if ! command -v python3 &> /dev/null; then
    echo "❌ ERROR: Python 3 n'est pas installé ou pas dans le PATH."
    echo "   Veuillez d'abord exécuter install.sh"
    exit 1
fi

# Vérifier si Flask est installé
if ! python3 -c "import flask" &> /dev/null; then
    echo "❌ ERROR: Flask n'est pas installé."
    echo "   Veuillez d'abord exécuter install.sh"
    exit 1
fi

# Vérifier si app.py existe
if [ ! -f "app.py" ]; then
    echo "❌ ERROR: app.py introuvable."
    echo "   Assurez-vous d'être dans le bon répertoire."
    exit 1
fi

echo "✅ OK Toutes les vérifications sont passées"
echo ""
echo "================================================"
echo "              🚀 LANCEMENT DU SERVEUR"
echo "================================================"
echo ""
echo "Le serveur web va démarrer..."
echo ""
echo "🌐 Ouvrez votre navigateur et allez sur :"
echo "   http://localhost:5000"
echo ""
echo "⏹️  Pour arrêter le serveur : Appuyez sur Ctrl+C"
echo ""
echo "================================================"
echo ""

# Lancer le serveur
python3 app.py
