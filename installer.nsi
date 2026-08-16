!include "MUI2.nsh"
!include "FileFunc.nsh"

Name "BrowserRMBG"
OutFile "BrowserRMBG_installer.exe"
InstallDir "$PROGRAMFILES64\BrowserRMBG"
RequestExecutionLevel admin

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "SimpChinese"

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  File "BrowserRMBG.exe"

  ; 开始菜单快捷方式
  CreateDirectory "$SMPROGRAMS\BrowserRMBG"
  CreateShortCut "$SMPROGRAMS\BrowserRMBG\BrowserRMBG.lnk" "$INSTDIR\BrowserRMBG.exe"

  CreateShortCut "$DESKTOP\BrowserRMBG.lnk" "$INSTDIR\BrowserRMBG.exe"

  ; 卸载信息
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BrowserRMBG" "DisplayName" "BrowserRMBG"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BrowserRMBG" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BrowserRMBG" "DisplayIcon" "$INSTDIR\BrowserRMBG.exe"
SectionEnd

Section "Uninstall"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\BrowserRMBG.exe"
  Delete "$SMPROGRAMS\BrowserRMBG\BrowserRMBG.lnk"
  RMDir "$SMPROGRAMS\BrowserRMBG"
  Delete "$DESKTOP\BrowserRMBG.lnk"
  RMDir "$INSTDIR"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BrowserRMBG"
SectionEnd
