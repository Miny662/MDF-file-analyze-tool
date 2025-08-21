# SYSTÈME EVA - GÉNÉRATEUR DE RAPPORTS D'ANALYSE
## AMPERE SOFTWARE TECHNOLOGY - RENAULT

Version 1.0.0 - Août 2024

---

## 📋 CONTENU DE LA LIVRAISON

### Scripts principaux
- `generate_eva_report_exact_template.py` - Générateur principal respectant le template exact
- `generate_eva_report_real_data.py` - Générateur avec extraction de données réelles
- `generate_eva_report_framework_complet.py` - Générateur avec framework UC complet

### Données de référence
- `tina/Labels Exemple (6).xlsx` - Base de données des signaux (339 signaux)
- `tina/rapport_eva_simple.docx` - Template de référence
- `tina/README_UC_FRAMEWORK.md` - Documentation du framework UC
- `tina/uc_detection_framework.json` - Framework de détection des UC

### Ressources
- `tina/renault.png` - Logo Renault
- `tina/Ampere.png` - Logo Ampere

### Exemples MDF
- `tina/Roulage.mdf`
- `tina/AcquiCAN_ChargeDC_Traction_Roulage.mdf`
- `tina/AcquiCAN_EndoRéveil.mdf`

---

## 🚀 INSTALLATION RAPIDE

### Windows
```bash
install.bat
```

### Linux/Mac
```bash
./install.sh
```

---

## 📦 INSTALLATION MANUELLE

### 1. Prérequis
- Python 3.8 ou supérieur
- pip (gestionnaire de packages Python)

### 2. Installation des dépendances
```bash
pip install -r requirements.txt
```

### 3. Vérification de l'installation
```bash
python generate_eva_report_exact_template.py --help
```

---

## 💻 UTILISATION

### Commande de base
```bash
python generate_eva_report_exact_template.py --mdf <fichier.mdf> --sweet <version> --myfx <config>
```

### Paramètres
- `--mdf` : Chemin vers le fichier MDF à analyser
- `--sweet` : Version SWEET (400 ou 500)
- `--myfx` : Configuration MyF (MyF2, MyF3, MyF4.1, MyF5, all)

### Exemples d'utilisation

#### Exemple 1 : Analyse simple
```bash
python generate_eva_report_exact_template.py --mdf tina/Roulage.mdf --sweet 400 --myfx all
```

#### Exemple 2 : Analyse avec configuration spécifique
```bash
python generate_eva_report_exact_template.py --mdf tina/AcquiCAN_ChargeDC_Traction_Roulage.mdf --sweet 500 --myfx MyF3
```

---

## 📊 RAPPORTS GÉNÉRÉS

Les rapports sont générés dans le dossier `eva_reports/` avec le format :
```
Rapport_EVA_EXACT_<SWEET>_<MyF>_<timestamp>.html
```

### Contenu du rapport
1. **Identification du véhicule** (VIN, Mulet, Date test)
2. **Use Cases détectés** (avec TSTART/TEND/Durée)
3. **Signaux EVA/SWEET** (31 signaux avec graphiques)
4. **Validation DOORS** (43 exigences)
5. **Résumé de l'analyse**

---

## 🔧 CONFIGURATION AVANCÉE

### Personnalisation des seuils
Éditer le fichier `tina/uc_detection_framework.json` pour ajuster :
- Seuils de détection
- Signaux requis par UC
- Règles booléennes

### Ajout de nouveaux signaux
1. Mettre à jour `tina/Labels Exemple (6).xlsx`
2. Régénérer le framework :
```bash
python extract_framework_from_excel.py
```

---

## 📁 STRUCTURE DES DOSSIERS

```
EVA_System/
├── generate_eva_report_exact_template.py  # Script principal
├── requirements.txt                       # Dépendances Python
├── install.sh                            # Script installation Linux/Mac
├── install.bat                           # Script installation Windows
├── README_CLIENT.md                      # Ce fichier
├── tina/                                 # Données de référence
│   ├── Labels Exemple (6).xlsx
│   ├── rapport_eva_simple.docx
│   ├── README_UC_FRAMEWORK.md
│   ├── uc_detection_framework.json
│   ├── renault.png
│   ├── Ampere.png
│   └── *.mdf                            # Fichiers MDF exemples
└── eva_reports/                          # Dossier de sortie (créé automatiquement)
```

---

## ❓ RÉSOLUTION DE PROBLÈMES

### Erreur : Module non trouvé
```bash
pip install --upgrade asammdf python-docx matplotlib pandas openpyxl
```

### Erreur : Fichier MDF non lisible
- Vérifier que le fichier n'est pas corrompu
- Vérifier les permissions de lecture
- Essayer avec un autre fichier MDF

### Erreur : Graphiques non générés
```bash
pip install --upgrade matplotlib
```

---

## 📞 SUPPORT

Pour toute question ou problème :
- Email : support@ampere-software.com
- Documentation : Voir `tina/README_UC_FRAMEWORK.md`

---

## 📄 LICENCE

© 2024 AMPERE SOFTWARE TECHNOLOGY - RENAULT
Tous droits réservés.

---

## 🔄 MISES À JOUR

Version 1.0.0 (Août 2024)
- Génération de rapports avec template exact
- Support des 43 exigences DOORS
- 31 signaux avec graphiques réels
- Extraction automatique VIN/Mulet
- Détection automatique des UC