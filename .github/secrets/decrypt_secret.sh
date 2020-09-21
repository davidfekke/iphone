#!/bin/sh

# Decrypt the file

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" \
  --output .github/secrets/DavidFekkeDistCert.p12 .github/secrets/DavidFekkeDistCert.p12.gpg

gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" \
  --output .github/secrets/InstanexIPhoneSampleDist.mobileprovision \
  .github/secrets/InstanexIPhoneSampleDist.mobileprovision.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/
echo "Move profiles"
cp .github/secrets/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/

security create-keychain -p "" build.keychain
security import .github/secrets/DavidFekkeDistCert.p12 -t agg \
  -k ~/Library/Keychains/build.keychain -P "$PASSPHRASE" -A

# install distribution cert and key
security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain
security set-key-partition-list -S apple-tool:,apple: -s \
  -k "" ~/Library/Keychains/build.keychain
