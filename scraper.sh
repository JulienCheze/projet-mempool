#!/bin/bash

# Fichier où stocker les données
CSV_FILE="data.csv"

# Créer le fichier avec les entêtes s’il n’existe pas encore
if [ ! -f "$CSV_FILE" ]; then
    echo "timestamp,fastestFee,nonConfirmedCount" > "$CSV_FILE"
fi

# Récupérer les données depuis les APIs
FEES_JSON=$(curl -s https://mempool.space/api/v1/fees/recommended)
MEMPOOL_JSON=$(curl -s https://mempool.space/api/mempool)

# Extraire les données avec grep/sed (ou jq si tu veux plus tard)
FASTEST_FEE=$(echo "$FEES_JSON" | grep -o '"fastestFee":[0-9]*' | grep -o '[0-9]*')
NON_CONFIRMED=$(echo "$MEMPOOL_JSON" | grep -o '"count":[0-9]*' | grep -o '[0-9]*')

# Timestamp actuel
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ajouter au CSV
echo "$TIMESTAMP,$FASTEST_FEE,$NON_CONFIRMED" >> "$CSV_FILE"


