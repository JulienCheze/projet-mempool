#!/bin/bash

CSV_FILE="data.csv"
REPORT_FILE="daily_report.txt"
TODAY=$(date '+%Y-%m-%d')

# Extraire les lignes d'aujourd'hui
grep "$TODAY" "$CSV_FILE" > today.csv

# Nombre de points
COUNT=$(wc -l < today.csv)
COUNT=$((COUNT - 1)) # on enlève l'entête

# Colonnes
FASTEST_FEES=$(cut -d',' -f2 today.csv | tail -n +2)
TX_COUNTS=$(cut -d',' -f3 today.csv | tail -n +2)

# Ouverture / clôture
OPEN=$(echo "$FASTEST_FEES" | head -n 1)
CLOSE=$(echo "$FASTEST_FEES" | tail -n 1)

# Moyenne et écart-type (volatilité) des TX non confirmées
AVG_TX=$(echo "$TX_COUNTS" | awk '{sum+=$1} END {print sum/NR}')
STD_TX=$(echo "$TX_COUNTS" | awk -v avg=$AVG_TX '{s+=$1; ss+=$1*$1} END {print sqrt(ss/NR - avg^2)}')

# Évolution en %
DELTA=$(echo "scale=2; 100*($CLOSE - $OPEN)/$OPEN" | bc)

# Écriture du rapport
echo "Rapport du $TODAY" > "$REPORT_FILE"
echo "Nombre de points : $COUNT" >> "$REPORT_FILE"
echo "Frais d'ouverture : $OPEN sat/vB" >> "$REPORT_FILE"
echo "Frais de clôture : $CLOSE sat/vB" >> "$REPORT_FILE"
echo "Évolution : $DELTA %" >> "$REPORT_FILE"
echo "Transactions non confirmées - Moyenne : $AVG_TX" >> "$REPORT_FILE"
echo "Transactions non confirmées - Volatilité : $STD_TX" >> "$REPORT_FILE"

