;--------------------------------
; Based on NSIS example1.nsi
; Copyright (c) 2001-2009 Sebastiaan Deckers
; License: GNU General Public License version 3 or later
; Description:
; Debugging tool for Pandion auto-update service.
; Reports the command line parameters and launches Pandion.

;--------------------------------
; Configuration
!define PRODUCT     "Pandion"
!define PRODUCTSAFE "Pandion"
InstallDir "$PROGRAMFILES\${PRODUCTSAFE}"
OutFile "echosetup.exe"

;--------------------------------
; Pages

Page directory
Page instfiles

;--------------------------------
; The stuff to install
Section "" ;No components page, name is not important

SectionEnd ; end the section

;--------------------------------
; Pre-install

Function .onInit

  ;--------------------------------
  ; Popup the command line parameters
  Call GetParameters
  Pop $R0
  MessageBox MB_OK "Parameters: <$R0>"

FunctionEnd

;--------------------------------
;Post-install

Function .onInstSuccess

  ExecWait "$\"$INSTDIR\${PRODUCTSAFE}.exe$\""

FunctionEnd

;--------------------------------
; GetParameters
; input, none
; output, top of stack (replaces, with e.g. whatever)
; modifies no other variables.

Function GetParameters
  Push $R0
  Push $R1
  Push $R2
  StrCpy $R0 $CMDLINE 1
  StrCpy $R1 '"'
  StrCpy $R2 1
  StrCmp $R0 '"' loop
    StrCpy $R1 ' ' ; we're scanning for a space instead of a quote
  loop:
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 loop2
    StrCmp $R0 "" loop2
    IntOp $R2 $R2 + 1
    Goto loop
  loop2:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " loop2
  StrCpy $R0 $CMDLINE "" $R2
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd
