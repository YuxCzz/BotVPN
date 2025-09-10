# update dulu
#apt update -y && apt upgrade -y

# install nodejs + npm
apt install -y nodejs npm

# install pm2 global
npm install -g pm2

# stop dulu servicenya
systemctl stop sellvpn.service

# nonaktifkan supaya tidak jalan saat boot
systemctl disable sellvpn.service
pm2 delete all
# hapus file service dari systemd
rm -f /etc/systemd/system/sellvpn.service

# reload systemd biar bersih
systemctl daemon-reload
systemctl reset-failed

cd /root/BotVPN
pm2 start ecosystem.config.js
pm2 save
cd 

cat >/usr/bin/backup_sellvpn <<'EOF'
#!/bin/bash
VARS_FILE="/root/BotVPN/.vars.json"
DB_FILE="/root/BotVPN/sellvpn.db"

if [ ! -f "$VARS_FILE" ]; then
    echo "❌ File $VARS_FILE tidak ditemukan"
    exit 1
fi

# Ambil nilai dari .vars.json
BOT_TOKEN=$(jq -r '.BOT_TOKEN' "$VARS_FILE")
USER_ID=$(jq -r '.USER_ID' "$VARS_FILE")

if [ -z "$BOT_TOKEN" ] || [ -z "$USER_ID" ]; then
    echo "❌ BOT_TOKEN atau USER_ID kosong di $VARS_FILE"
    exit 1
fi

# Kirim database ke Telegram
if [ -f "$DB_FILE" ]; then
    curl -s -F chat_id="$USER_ID" \
         -F document=@"$DB_FILE" \
         "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" >/dev/null 2>&1
    echo "✅ Backup terkirim ke Telegram"
else
    echo "❌ Database $DB_FILE tidak ditemukan"
fi
EOF

# bikin cron job tiap 1 jam
cat >/etc/cron.d/backup_sellvpn <<'EOF'
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/backup_sellvpn
EOF

chmod +x /usr/bin/backup_sellvpn
service cron restart
