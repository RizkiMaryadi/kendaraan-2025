# PERHATIAN HARAP DI BACA DENGAN CERMAT DAN TELITI
# CONFIGURATION PROJECT
## CROSSCHECK REQUIREMENT
1. PASTIKAN WSL ANDA SUDAH ROOT
```php
whoami
```
HASIL :
❯ whoami
root

## SETUP AWAL
1. BUKA GITHUB DAN AMBIL SETTING ATAU BISA COPY PASTE URL DIBAWAH INI
```php
    https://github.com/settings/tokens
```
2. SELANJUTNYA AMBIL MENU PERSONAL ACCESS TOKEN (MASIH DIDALAM SETTING GITHUB)
3. PILIH MENU TOKEN (classic) dan GENERATE NEW TOKEN PILIHANNYA GENERATE TOKEN CLASSIC !!!
4. ISI NOTE DENGAN INITSCRIPT
5. SET EXPIRATION TO NO EXPIRATION
6. CENTANG SEMUA REPO, USER DAN DELETE_REPO
7. BUAT FILE DIDALAM BOILERPLATE DENGAN NAMA ".github-user dan .github-token" ATAU BISA COPY PASTE CMD DIBAWAH INI DI DALAM BOILERPLATE
```php
touch .github-token
```
```php
touch .github-user
```
8. DI DALAM FILE .github-token PASTE TOKEN YANG TELAH DI GENERATE TADI
9. DI DALAM FILE .github-user KETIKKAN USER GITHUB ANDA

## SETUP KEDUA DI DALAM POWERSHELL DENGAN RUN ADMINISTRATOR
1. LAKUKAN DI POWERSHELL DENGAN RUN AS ADMINISTRATOR
```php
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
2. MASIH DI POWERSHELL DENGAN RUN AS ADMINISTRATOR
```php
choco install mkcert
```
3. MASIH DI POWERSHELL DENGAN RUN AS ADMINISTRATOR
```php
mkcert -install
```
4. RESTART LAPTOP KALIAN

### JIKA ERROR TIDAK BISA INSTALL COBA LANGKAH INI MASIH DILAKUKAN DENGAN POWERSHELL RUN AS ADMINISTRATOR
#### SATU
```php
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.IO.Directory]::Delete("$env:ProgramData\chocolatey", $true)
```

#### DUA
```php
$envPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
$newPath = ($envPath -split ";") -ne "C:\ProgramData\chocolatey\bin" -join ";"
[Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::Machine)
```

## UNTUK MEMULAI SILAHKAN LAKUKAN PERINTAH BERIKUT INI 
### MISALNYA NAMA PROJECT NYA ADALAH PEMWEB 
```php
start pemweb
```
## SETUP TERAKHIR DIDALAM TERMINAL WSL
1. SETELAH SELESAI SEMUA BISA LAKUKAN SOURCE ULANG ZSHRC ATAU BISA COPY PASTE CMD DIBAWAH INI
```php
source /root/.zshrc
```
2. AKAN ADA TAMBAHAN PERINTAH SEPERTI
- dcu (untuk docker-compose up -d)
- dcd (untuk docker-compose down)
- dcm (untuk create model -mcs)
- dci (untuk project init dimana sudah termasuk migrate, seed, fresh)
- dcv (untuk create filament resource --generate)
- dcr (untuk remove model,cont,seeder,migration)
- dcp (untuk git push)