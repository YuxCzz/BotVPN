// api-cekpayment-orkut.js
const qs = require('qs');

// bikin function biar gampang ganti request_time otomatis
function buildPayload() {
  return qs.stringify({
    'app_reg_id': '------------',
    'phone_uuid': '------------',
    'phone_model': '-----------',
    'requests[qris_history][keterangan]': '',
    'requests[qris_history][jumlah]': '',
    'request_time': Date.now().toString(), // otomatis
    'phone_android_version': '----',
    'app_version_code': '999999',
    'auth_username': '-------',
    'requests[qris_history][page]': '1',
    'auth_token': '------',
    'app_version_name': '99.99.99',
    'ui_mode': 'dark'
  });
}

const headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Accept-Encoding': 'gzip',
  'User-Agent': 'okhttp/4.12.0'
};

// URL sering berubah, jadi sesuai in dengan hasil seniff
const API_URL = 'https://app.orderkuota.com/api/v2/qris/mutasi/1xxxx';

module.exports = { buildPayload, headers, API_URL };
