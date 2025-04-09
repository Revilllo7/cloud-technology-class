#!/bin/bash

VOLUME_NAME=$1
PASSWORD=$2

if [ -z "$VOLUME_NAME" ] || [ -z "$PASSWORD" ]; then
    echo "Użycie: ./secure.sh <nazwa_wolumenu> <hasło>"
    exit 1
fi

# Pobranie punktu montowania wolumenu
MOUNT_POINT=$(docker volume inspect --format '{{ .Mountpoint }}' "$VOLUME_NAME")

if [ ! -d "$MOUNT_POINT" ]; then
    echo "Błąd: Wolumen $VOLUME_NAME nie istnieje."
    exit 1
fi

# Tworzenie archiwum
ARCHIVE_NAME="${VOLUME_NAME}.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$MOUNT_POINT" .

# Szyfrowanie pliku archiwum
gpg --batch --yes --passphrase "$PASSWORD" -c "$ARCHIVE_NAME"

# Czyszczenie plików tymczasowych
rm -f "$ARCHIVE_NAME"

echo "Wolumen $VOLUME_NAME został zabezpieczony jako ${ARCHIVE_NAME}.gpg"
