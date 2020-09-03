#!/bin/bash
#path to xkblayout installation
xkbl_install_path="$HOME/src/xkblayout-state/xkblayout-state"
#path to python bin to be used
python_to_use="$HOME/miniconda3/bin/python"
# array of applications where shortcut wont substitute highlighted
declare -a EXCLUDING=()
# array of applications where use the ctrl+shift+v to paste
declare -a SHIFT_PASTE=("zsh — Konsole")



layout=$($xkbl_install_path print "%n")
text=$(xsel -o)
active_window=$(xdotool getwindowfocus getwindowname)

for i in "${EXCLUDING[@]}"
do
    if [[ $active_window = *"$i"* ]]
    then
        exit 0
    fi     
done

processed_text=$(
$python_to_use - <<EOF
from keyw import engrus,ruseng
import sys
CONVERTERS = {'Russian':ruseng,'English':engrus}
convert_fun = CONVERTERS["$layout"]
sys.stdout.write(convert_fun(r"$text"))
EOF
) 
printf "$processed_text" | xclip -i -se c
for i in "${SHIFT_PASTE[@]}"
do  
    if [[ $active_window = *"$i"* ]]
    then 
        xdotool key --clearmodifiers ctrl+shift+v
        exit 0
    fi     
done

xdotool key --clearmodifiers ctrl+v
#xdotool key --clearmodifiers ctrl+shift+v