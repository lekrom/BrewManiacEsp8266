#!/bin/bash

OUTDIR="cheader"
DISTDIR="dist"

if [ ! -d $OUTDIR ]; then
    echo "$OUTDIR not found!"
    mkdir "$OUTDIR"
fi
rm $OUTDIR/*.h

htmlfiles=(bm.htm.gz)
variables=(data_bm_htm_gz)
outfiles=(bm_htm)
languages=(english spanish portuguese-br russian italiano)

echo "Embedding HTML files to C-style headers..."

gen_C_file()
{
lang=$1
for ((index=0; index<${#htmlfiles[@]}; index++)); do
    srcdir="dist/$lang"

#   echo "[$index]: ${htmlfiles[$index]}"
   input="$srcdir/${htmlfiles[$index]}"
   output="$OUTDIR/${lang}_${outfiles[$index]}.h"
   variable=${variables[$index]}
   #echo "input: $input output file: $output with variables $variable "
   xxd -i  "$input" > $output 
   echo "processing $output"
   sed -i "s/unsigned char .\+\[\]/const unsigned char $variable\[\] PROGMEM/" $output
done
}

for lang in "${languages[@]}"
do
gen_C_file $lang
done
