#!/bin/bash

VOLUME_NAME=$1
PASSWORD=$2

if [ -z "$VOLUME_NAME" ] || [ -z "$PASSWORD" ]; then
    echo "Użycie: ./decrypt.sh <nazwa_wolumenu> <hasło>"
    exit 1
fi

ENCRYPTED_FILE="${VOLUME_NAME}.tar.gz.gpg"
DECRYPTED_FILE="${VOLUME_NAME}.tar.gz"

if [ ! -f "$ENCRYPTED_FILE" ]; then
    echo "Błąd: Zaszyfrowany plik $ENCRYPTED_FILE nie istnieje."
    exit 1
fi

# Odszyfrowanie pliku
gpg --batch --yes --passphrase "$PASSWORD" -o "$DECRYPTED_FILE" -d "$ENCRYPTED_FILE"

# Rozpakowanie plików do wolumenu
MOUNT_POINT=$(docker volume inspect --format '{{ .Mountpoint }}' "$VOLUME_NAME")

if [ ! -d "$MOUNT_POINT" ]; then
    echo "Błąd: Wolumen $VOLUME_NAME nie istnieje."
    exit 1
fi

tar -xzf "$DECRYPTED_FILE" -C "$MOUNT_POINT"

# Czyszczenie plików tymczasowych
rm -f "$DECRYPTED_FILE"

echo "Wolumen $VOLUME_NAME został odszyfrowany i przywrócony."
