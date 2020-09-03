#!/bin/bash
xkbl_install_path="$HOME/src/xkblayout-state/xkblayout-state"
python_to_use="$HOME/miniconda3/bin/python"
layout=$($xkbl_install_path print "%n")
text=$(xsel -o)
processed_text=$(
$python_to_use - <<EOF
from keyw import engrus,ruseng
import sys
CONVERTERS = {'Russian':ruseng,'English':engrus}
convert_fun = CONVERTERS["$layout"]
sys.stdout.write(convert_fun("$text"))
EOF
) 
printf "$processed_text" | xclip -i -se c
xdotool key --clearmodifiers ctrl+v
