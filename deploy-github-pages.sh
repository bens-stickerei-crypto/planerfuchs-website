#!/bin/bash
# PlanerFuchs Website - GitHub Pages Deployment
# Fuehre dieses Script im website/ Ordner aus.
#
# Voraussetzungen:
# 1. Git installiert (git --version)
# 2. GitHub Account vorhanden
# 3. GitHub CLI installiert: https://cli.github.com/
#    ODER manuell ein Repository auf github.com erstellen
#
# Anleitung:
#   cd "C:/Users/benne/Desktop/KI Angestellter/website"
#   bash deploy-github-pages.sh

set -e

REPO_NAME="planerfuchs-website"

echo "=== PlanerFuchs Website - GitHub Pages Deployment ==="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "[FEHLER] Git ist nicht installiert."
    echo "         Download: https://git-scm.com/download/win"
    exit 1
fi

# Initialize git repo if not already
if [ ! -d ".git" ]; then
    echo "[1/5] Initialisiere Git Repository..."
    git init
    git branch -M main
else
    echo "[1/5] Git Repository existiert bereits."
fi

# Add all files
echo "[2/5] Fuege Dateien hinzu..."
git add -A
git commit -m "PlanerFuchs Website - Initial Deployment

Enthaltene Seiten:
- Startseite mit 20+ Produkten und 3 Bundles
- Blog: KI-Tools 2026, EU AI Act, Sparen mit ChatGPT
- SEO-optimiert mit sitemap.xml und robots.txt

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"

# Check for gh CLI
if command -v gh &> /dev/null; then
    echo "[3/5] Erstelle GitHub Repository..."
    gh repo create "$REPO_NAME" --public --source=. --push

    echo "[4/5] Aktiviere GitHub Pages..."
    gh api -X POST "repos/$(gh api user --jq .login)/$REPO_NAME/pages" \
        -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || \
    gh api -X PUT "repos/$(gh api user --jq .login)/$REPO_NAME/pages" \
        -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || true

    USERNAME=$(gh api user --jq .login)
    echo ""
    echo "[5/5] FERTIG!"
    echo ""
    echo "  Website URL: https://${USERNAME}.github.io/${REPO_NAME}/"
    echo "  Repository:  https://github.com/${USERNAME}/${REPO_NAME}"
    echo ""
    echo "  Hinweis: GitHub Pages braucht 1-2 Minuten zum Deployen."
    echo "           Dann ist die Website unter der URL oben erreichbar."
else
    echo ""
    echo "[3/5] GitHub CLI nicht gefunden. Manuelle Schritte:"
    echo ""
    echo "  OPTION A: GitHub CLI installieren (empfohlen)"
    echo "    1. Download: https://cli.github.com/"
    echo "    2. Installieren und 'gh auth login' ausfuehren"
    echo "    3. Dieses Script nochmal starten"
    echo ""
    echo "  OPTION B: Manuell auf github.com"
    echo "    1. Gehe zu https://github.com/new"
    echo "    2. Repository Name: $REPO_NAME"
    echo "    3. Visibility: Public"
    echo "    4. Create repository (OHNE README/gitignore)"
    echo "    5. Fuehre diese Befehle aus:"
    echo ""
    echo "       git remote add origin https://github.com/DEIN-USERNAME/$REPO_NAME.git"
    echo "       git push -u origin main"
    echo ""
    echo "    6. Gehe zu Repository Settings > Pages"
    echo "    7. Source: Deploy from branch > main > / (root)"
    echo "    8. Save"
    echo ""
    echo "  Die Website ist dann unter:"
    echo "  https://DEIN-USERNAME.github.io/$REPO_NAME/"
fi
