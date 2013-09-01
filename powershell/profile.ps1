# This should be put into $profile
set-alias np notepad

function extract-zip($file) {Start-Process -NoNewWindow "C:\Program Files\7-Zip\7z.exe" x,$file}
set-alias unzip extract-zip

function move-cygwin {cd C:\cygwin\home\anonymous}
set-alias cygwin move-cygwin

function move-home {cd C:\Users\anonymous}
set-alias home move-home

