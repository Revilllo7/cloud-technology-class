#!/bin/bash

echo "Sprawdzanie zużycia przestrzeni dla wszystkich wolumenów Docker..."

# Pobranie listy wolumenów
volumes=$(docker volume ls -q)

# Nagłówek tabeli
printf "%-20s %-10s %-10s %-10s\n" "Wolumen" "Użycie" "Rozmiar" "Zajętość"

# Iteracja przez każdy wolumen
for volume in $volumes; do
    mount_point=$(docker volume inspect --format '{{ .Mountpoint }}' "$volume")

    # Sprawdzenie, czy katalog istnieje (wolumen może być usunięty)
    if [ -d "$mount_point" ]; then
        usage_info=$(df -h "$mount_point" | awk 'NR==2 {print $3, $2, $5}')
        printf "%-20s %-10s %-10s %-10s\n" "$volume" $usage_info
    else
        echo "Nie można znaleźć punktu montowania dla wolumenu: $volume"
    fi
done
