@echo off
setlocal enabledelayedexpansion
title WARP Proxy for Discord

:: Karakter seti uyumu
chcp 1254 >nul

echo ==============================================================
echo [^^!] DÝKKAT: Cloudflare One Client üzerinden "Yerel Proxy" 
echo (Local Proxy) modunun açýk ve 127.0.0.1:40000 portunda 
echo çalýþtýðýndan emin olun.
echo ==============================================================
echo.
echo Ýþleme devam etmek için bir tuþa basýn...
pause >nul

:: --- YAPILANDIRMA ---
set "SINGBOX_EXE=sing-box.exe"
set "SINGBOX_CONFIG=sing-box.json"
set "DLL_SOURCE=version.dll"
set "SINGBOX_PORT=40001"
set "VBS_NAME=opendiscord.vbs"

set "VBS_PATH=%~dp0%VBS_NAME%"
set "FULL_SINGBOX_PATH=%~dp0%SINGBOX_EXE%"
set "FULL_SINGBOX_CONFIG_PATH=%~dp0%SINGBOX_CONFIG%"
set "FULL_DLL_SOURCE=%~dp0%DLL_SOURCE%"

echo [+] Baþlatýcý dosyasý (VBS) oluþturuluyor...

:: --- VBS OLUÞTURMA ---
(
echo Option Explicit
echo Dim fso, shell, localAppData, discordPath, latestAppFolder, appSubFolder, targetDll, command, pName, processes
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo Set shell = CreateObject^("WScript.Shell"^)
echo.
echo ' --- Mevcut süreçleri zorla sonlandýr ---
echo processes = Array^("sing-box.exe", "discord.exe"^)
echo For Each pName In processes
echo     On Error Resume Next
echo     shell.Run "taskkill /F /T /IM " ^& pName, 0, True
echo     On Error GoTo 0
echo Next
echo WScript.Sleep 100
echo.
echo ' --- sing-box'ý Arka Planda Baþlat ---
echo shell.Run "cmd /c start """" /b ""%FULL_SINGBOX_PATH%"" run -c ""%FULL_SINGBOX_CONFIG_PATH%""", 0, False
echo WScript.Sleep 100
echo.
echo ' --- Discord LocalAppData Klasörünü Hedef Al ---
echo localAppData = shell.ExpandEnvironmentStrings^("%%localappdata%%"^)
echo discordPath = localAppData ^& "\Discord"
echo.
echo If fso.FolderExists^(discordPath^) Then
echo     ' app- ile baþlayan aktif sürüm klasörünü doðrudan buluyoruz
echo     For Each appSubFolder In fso.GetFolder^(discordPath^).SubFolders
echo         If InStr^(LCase^(appSubFolder.Name^), "app-"^) ^> 0 Then
echo             latestAppFolder = appSubFolder.Path
echo         End If
echo     Next
echo.
echo     ' Eðer sürüm klasörü bulunduysa DLL kopyala ve Discord'u baþlat
echo     If Not latestAppFolder = "" Then
echo         targetDll = latestAppFolder ^& "\version.dll"
echo         If fso.FileExists^("%FULL_DLL_SOURCE%"^) Then
echo             On Error Resume Next
echo             fso.CopyFile "%FULL_DLL_SOURCE%", targetDll, True
echo             On Error GoTo 0
echo         End If
echo.
echo         ' --- Discord'u Update.exe üzerinden Proxy Parametresiyle Baþlatma ---
echo         command = "cmd /c start """" /b """ ^& discordPath ^& "\Update.exe"" --processStart Discord.exe --a=--proxy-server=http://127.0.0.1:%SINGBOX_PORT%"
echo         shell.Run command, 0, False
echo     End If
echo End If
) > "%VBS_PATH%"

echo [+] VBS dosyasý baþarýyla oluþturuldu.

:: --- KISAYOL VE STARTUP ÝÞLEMLERÝ ---
echo.
echo [+] Masaüstü kýsayolu oluþturuluyor...
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "REAL_DESKTOP=%%i"
set "SC_PATH=!REAL_DESKTOP!\Discord (WARP).lnk"
set "WK_DIR=%~dp0"

powershell -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('!SC_PATH!'); $s.TargetPath = '%VBS_PATH%'; $s.WorkingDirectory = '!WK_DIR!'; $s.IconLocation = '%LOCALAPPDATA%\Discord\app.ico'; $s.Save()"

if !errorlevel! equ 0 (
    echo [+] Masaüstü kýsayolu baþarýyla oluþturuldu.
) else (
    echo [-] HATA: Kýsayol oluþturulamadý!
)

echo.
set /p "ans_startup=[?] Sistem açýlýþýna (Startup) eklensin mi? (E/H): "
if /i "%ans_startup%"=="E" (
    set "DST_LNK=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Discord (WARP).lnk"
    
    powershell -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('!DST_LNK!'); $s.TargetPath = '%VBS_PATH%'; $s.WorkingDirectory = '%~dp0'; $s.IconLocation = '%LOCALAPPDATA%\Discord\app.ico'; $s.Save()"
    
    if !errorlevel! equ 0 (
        echo [+] Baþlangýca eklendi.
    ) else (
        echo [-] HATA: Baþlangýca eklenemedi!
    )
)

echo.
echo ÝÞLEM TAMAMLANDI. Kýsayolu kullanarak Discord'u baþlatabilirsiniz.
pause
exit