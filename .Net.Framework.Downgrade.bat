@echo off
chcp 65001
@echo off

rem "---------------------------------------"
rem ".Net Framework 4.8 ダウングレードバッチファイル"
rem "Ver 0.02"
rem "---------------------------------------"

rem "---------------------------------------"
rem "※※※ダウングレード元に使用するフォルダを設定※※※"
rem "---------------------------------------"
set dotNetFolder=C:\Windows.old\WINDOWS\Microsoft.NET

rem "---------------------------------------"
rem "64bitか32bitかをチェック CODE-01"
rem "---------------------------------------"
if not %PROCESSOR_ARCHITECTURE%==AMD64 (
  echo Windows 32bit x86では実行できません
  echo ダウングレードを中止します CODE-01
  pause
  goto :eof
)

rem "---------------------------------------"
rem "管理者権限チェック CODE-02"
rem "---------------------------------------"
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
  if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
  if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ADMIN%" neq "yes" (
  echo 管理者権限で実行して下さい。ダウングレードを中止します CODE-02
  echo You may need to adjust admin and elevated checking depending on your language.
  pause
  goto :eof
)
if "%ELEVATED%" neq "yes" (
  echo 管理者権限で実行して下さい。ダウングレードを中止します CODE-02
  echo You may need to adjust admin and elevated checking depending on your language.
  pause
  goto :eof
)

rem "---------------------------------------"
rem "プロセスチェック CODE-03"
rem "---------------------------------------"
tasklist | find "WmiPrvSE.exe" > NUL
if %ERRORLEVEL% == 0 (
  echo "WmiPrvSE.exe"が起動中です。共有違反が発生しないよう強制終了します。 CODE-03
  Taskkill /F /IM WmiPrvSE.exe
)

:Answer
echo ---------------------------------------
echo .Net Framework 4.8をダウングレードします。

echo このプログラムが失敗したらやり直しできません。

echo このプログラムが成功しても元に戻せません。

echo 何が起きても私はあなたに対して一切の責任を負いかねます。

echo ※ From: %dotNetFolder%
echo ※ To:   %SystemRoot%\Microsoft.NET
echo ---------------------------------------
SET /P ANSWER="それでもダウングレードしますか (Y/N)？"

if /i {%ANSWER%}=={y} (goto :InstallStart)
if /i {%ANSWER%}=={yes} (goto :InstallStart)
echo ダウングレードを中止します
goto :eof

rem "---------------------------------------"
rem "ダウングレード開始"
rem "---------------------------------------"
:InstallStart
echo ●.Net Framework 4.8 ダウングレード開始
echo.

rem "---------------------------------------"
rem "カレントディレクトリをこのファイルのあるフォルダに設定"
rem "---------------------------------------"
cd /d %~dp0

rem "---------------------------------------"
rem "コピー元の Framework があるかどうか調べる CODE-11"
rem "---------------------------------------"
IF NOT EXIST %dotNetFolder%\Framework\v4.0.30319 (
  echo フォルダ %dotNetFolder%\Framework\v4.0.30319 がありません
  echo ダウングレードを中止します CODE-11
  pause
  goto :eof
)

rem "---------------------------------------"
rem "コピー元の Framework64 があるかどうか調べる CODE-12"
rem "---------------------------------------"
IF NOT EXIST %dotNetFolder%\Framework64\v4.0.30319 (
  echo フォルダ %dotNetFolder%\Framework64\v4.0.30319 がありません
  echo ダウングレードを中止します CODE-12
  pause
  goto :eof
)

rem "---------------------------------------"
rem "コピー元の assembly があるかどうか調べる CODE-13"
rem "---------------------------------------"
IF NOT EXIST %dotNetFolder%\assembly (
  echo フォルダ %dotNetFolder%\assembly がありません
  echo ダウングレードを中止します CODE-13
  pause
  goto :eof
)

rem "---------------------------------------"
rem ".Net Framework を C:\Windows\Microsoft.NET\ へコピー"
rem "---------------------------------------"
echo ●.Net Framework 4.8 ファイルコピー処理中

rem "---------------------------------------"
rem "OS側のパスを指定"
SET OSPath=%SystemRoot%\Microsoft.NET\Framework\v4.0.30319

rem "コピー元のパスを指定"
SET CopyPath=%dotNetFolder%\Framework\v4.0.30319

rem "OS側にある clr.dll の所有権を自分に設定"
takeown /f "%OSPath%\*" /r
echo.

rem "OS側にある clr.dll のフルアクセス権を自分に設定"
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem "clr.dll をOS側へ上書きコピー"
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem "clr.dll の所有権を TrustedInstaller に設定"
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem "clr.dll のアクセス権から自分を削除"
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem "---------------------------------------"
rem "OS側のパスを指定"
SET OSPath=%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319

rem "コピー元のパスを指定"
SET CopyPath=%dotNetFolder%\Framework64\v4.0.30319

rem "OS側にある clr.dll の所有権を自分に設定"
takeown /f "%OSPath%\*" /r
echo.

rem "OS側にある clr.dll のフルアクセス権を自分に設定"
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem "clr.dll をOS側へ上書きコピー"
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem "clr.dll の所有権を TrustedInstaller に設定"
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem "clr.dll のアクセス権から自分を削除"
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem "---------------------------------------"
rem "OS側のパスを指定"
SET OSPath=%SystemRoot%\Microsoft.NET\assembly

rem "コピー元のパスを指定"
SET CopyPath=%dotNetFolder%\assembly

rem "OS側にある clr.dll の所有権を自分に設定"
takeown /f "%OSPath%\*" /r
echo.

rem "OS側にある clr.dll のフルアクセス権を自分に設定"
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem "clr.dll をOS側へ上書きコピー"
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem "clr.dll の所有権を TrustedInstaller に設定"
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem "clr.dll のアクセス権から自分を削除"
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem "---------------------------------------"
echo ●ダウングレードが正常に完了しました
pause
goto :eof

:Error
echo ●エラーが発生しました、ダウングレードを中止します
pause
goto :eof
