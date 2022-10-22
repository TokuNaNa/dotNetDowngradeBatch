@echo off
chcp 932

rem ---------------------------------------
rem .Net Framework 4.8 �_�E���O���[�h�o�b�`�t�@�C��
rem Ver 0.01
rem ---------------------------------------

rem ---------------------------------------
rem �������_�E���O���[�h���Ɏg�p����t�H���_��ݒ聦����
rem ---------------------------------------
set dotNetFolder=C:\Windows.old\WINDOWS\Microsoft.NET

rem ---------------------------------------
rem 64bit��32bit�����`�F�b�N
rem ---------------------------------------
if not %PROCESSOR_ARCHITECTURE%==AMD64 (
  echo Windows 32bit x86�ł͎��s�ł��܂���
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)

rem ---------------------------------------
rem �Ǘ��Ҍ����`�F�b�N
rem ---------------------------------------
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
  if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
  if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ADMIN%" neq "yes" (
  echo �Ǘ��Ҍ����Ŏ��s���ĉ�����
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)
if "%ELEVATED%" neq "yes" (
  echo �Ǘ��Ҍ����Ŏ��s���ĉ�����
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)

:Answer
echo ---------------------------------------
echo .Net Framework 4.8���_�E���O���[�h���܂��B
echo ���̃v���O���������s�������蒼���ł��܂���B
echo ���̃v���O�������������Ă����ɖ߂��܂���B
echo �����N���Ă����͂��Ȃ��ɑ΂��Ĉ�؂̐ӔC�𕉂����˂܂��B
echo �� From: %dotNetFolder%
echo �� To:   %SystemRoot%\Microsoft.NET
echo ---------------------------------------
SET /P ANSWER="����ł��_�E���O���[�h���܂��� (Y/N)�H"

if /i {%ANSWER%}=={y} (goto :InstallStart)
if /i {%ANSWER%}=={yes} (goto :InstallStart)
echo �_�E���O���[�h�𒆎~���܂�
goto :eof

rem ---------------------------------------
rem �_�E���O���[�h�J�n
rem ---------------------------------------
:InstallStart
echo ��.Net Framework 4.8 �_�E���O���[�h�J�n
echo.

rem ---------------------------------------
rem �J�����g�f�B���N�g�������̃t�@�C���̂���t�H���_�ɐݒ�
rem ---------------------------------------
cd /d %~dp0

rem ---------------------------------------
rem �R�s�[���� Framework �����邩�ǂ������ׂ�
rem ---------------------------------------
IF NOT EXIST %dotNetFolder%\Framework\v4.0.30319 (
  echo �t�H���_ %dotNetFolder%\Framework\v4.0.30319 ������܂���
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)

rem ---------------------------------------
rem �R�s�[���� Framework64 �����邩�ǂ������ׂ�
rem ---------------------------------------
IF NOT EXIST %dotNetFolder%\Framework64\v4.0.30319 (
  echo �t�H���_ %dotNetFolder%\Framework64\v4.0.30319 ������܂���
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)

rem ---------------------------------------
rem �R�s�[���� assembly �����邩�ǂ������ׂ�
rem ---------------------------------------
IF NOT EXIST %dotNetFolder%\assembly (
  echo �t�H���_ %dotNetFolder%\assembly ������܂���
  echo �_�E���O���[�h�𒆎~���܂�
  pause
  goto :eof
)

rem ---------------------------------------
rem .Net Framework �� C:\Windows\Microsoft.NET\ �փR�s�[
rem ---------------------------------------
echo ��.Net Framework 4.8 �t�@�C���R�s�[������

rem ---------------------------------------
rem OS���̃p�X���w��
SET OSPath=%SystemRoot%\Microsoft.NET\Framework\v4.0.30319

rem �R�s�[���̃p�X���w��
SET CopyPath=%dotNetFolder%\Framework\v4.0.30319

rem OS���ɂ��� clr.dll �̏��L���������ɐݒ�
takeown /f "%OSPath%\*" /r
echo.

rem OS���ɂ��� clr.dll �̃t���A�N�Z�X���������ɐݒ�
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem clr.dll ��OS���֏㏑���R�s�[
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem clr.dll �̏��L���� TrustedInstaller �ɐݒ�
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem clr.dll �̃A�N�Z�X�����玩�����폜
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem ---------------------------------------
rem OS���̃p�X���w��
SET OSPath=%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319

rem �R�s�[���̃p�X���w��
SET CopyPath=%dotNetFolder%\Framework64\v4.0.30319

rem OS���ɂ��� clr.dll �̏��L���������ɐݒ�
takeown /f "%OSPath%\*" /r
echo.

rem OS���ɂ��� clr.dll �̃t���A�N�Z�X���������ɐݒ�
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem clr.dll ��OS���֏㏑���R�s�[
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem clr.dll �̏��L���� TrustedInstaller �ɐݒ�
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem clr.dll �̃A�N�Z�X�����玩�����폜
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem ---------------------------------------
rem OS���̃p�X���w��
SET OSPath=%SystemRoot%\Microsoft.NET\assembly

rem �R�s�[���̃p�X���w��
SET CopyPath=%dotNetFolder%\assembly

rem OS���ɂ��� clr.dll �̏��L���������ɐݒ�
takeown /f "%OSPath%\*" /r
echo.

rem OS���ɂ��� clr.dll �̃t���A�N�Z�X���������ɐݒ�
icacls "%OSPath%\*" /T /grant "%UserName%":F
echo.

rem clr.dll ��OS���֏㏑���R�s�[
xcopy /r /y /h /q "%CopyPath%" "%OSPath%"
echo.
if errorlevel 1 goto :Error

rem clr.dll �̏��L���� TrustedInstaller �ɐݒ�
icacls "%OSPath%\*" /T /setowner "NT Service\TrustedInstaller"
echo.

rem clr.dll �̃A�N�Z�X�����玩�����폜
icacls "%OSPath%\*" /T /remove "%UserName%"
echo.

rem ---------------------------------------
echo ���_�E���O���[�h������Ɋ������܂���
goto :eof

:Error
echo ���G���[���������܂����A�_�E���O���[�h�𒆎~���܂�
pause
goto :eof
