#!/usr/bin/env bash

# WARP Discord Proxy macOS Otomatik Kurulum Betiği
# Tek satır kurulum: bash <(curl -sSL https://raw.githubusercontent.com/alimali54/WARP-Proxy-for-Discord/main/mac/install.sh)

echo "=============================================================="
echo "          WARP Discord Proxy macOS Installer                  "
echo "=============================================================="
echo ""

# Kendi GitHub deponuzun yolunu buraya yazın:
REPO="alimali54/WARP-Proxy-for-Discord"
VERSION="v1.1"

# --- 1. MİMARİ TESPİTİ ---
echo "[1/4] Sistem mimarisi tespit ediliyor..."
ARCH="$(uname -m)"

if [ "$ARCH" = "arm64" ]; then
    echo "  [+] Apple Silicon (M serisi) mimarisi tespit edildi."
    RELEASE_FILE="WARP.Proxy.for.Discord.v.1.1-mac-arm64.zip"
else
    echo "  [+] Intel (x86_64) mimarisi tespit edildi."
    RELEASE_FILE="WARP.Proxy.for.Discord.v.1.1-mac-amd64.zip"
fi

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${RELEASE_FILE}"

# --- 2. İNDİRME ---
echo "[2/4] Gerekli dosyalar indiriliyor..."
INSTALL_DIR="$HOME/WARP_Discord_Proxy"
mkdir -p "$INSTALL_DIR"
cd "$HOME" || exit 1

curl -fL --progress-bar -o "$RELEASE_FILE" "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
    echo "[-] HATA: İndirme başarısız oldu!"
    echo "    URL kontrol edin: $DOWNLOAD_URL"
    exit 1
fi

# --- 3. ZIP ÇIKARTMA VE DİZİNİ DÜZLEŞTİRME ---
echo "[3/4] Dosyalar çıkartılıyor ve dizin düzenleniyor..."
TEMP_EXTRACT="$INSTALL_DIR/temp_extract"
mkdir -p "$TEMP_EXTRACT"
unzip -q -o "$RELEASE_FILE" -d "$TEMP_EXTRACT"
rm -f "$RELEASE_FILE"

# install.command (veya install.sh) dosyasının olduğu en dipteki klasörü bul
FOUND_SCRIPT=$(find "$TEMP_EXTRACT" -name "install.command" -o -name "install.sh" | head -n 1)

if [ -z "$FOUND_SCRIPT" ]; then
    echo "[-] HATA: Çıkartılan dosyalar arasında install.command bulunamadı!"
    rm -rf "$TEMP_EXTRACT"
    exit 1
fi

SOURCE_DIR="$(dirname "$FOUND_SCRIPT")"

# Tüm asıl dosyaları direkt ~/WARP_Discord_Proxy köküne taşı
cp -R "$SOURCE_DIR/"* "$INSTALL_DIR/" 2>/dev/null
rm -rf "$TEMP_EXTRACT"

# --- 4. İZİNLER VE BAŞLATMA ---
echo "[4/4] İzinler yapılandırılıyor ve kurulum başlatılıyor..."
cd "$INSTALL_DIR" || exit 1

# Mac güvenlik ve çalışma izinlerini ayarla
chmod +x *.command *.sh sing-box 2>/dev/null
xattr -cr . 2>/dev/null

# Uygun scripti çalıştır
if [ -f "install.command" ]; then
    ./install.command
elif [ -f "install.sh" ]; then
    ./install.sh
fi
