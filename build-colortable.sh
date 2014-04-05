#!/bin/bash

o=colortable

make_tablehead(){
  echo '\begin{tabular}{>{\ttfamily}rl}'
}

make_tableend(){
  echo '\end{tabular}'
}

{
  echo '
\documentclass[border=1cm]{standalone}
\usepackage{array}
\usepackage[all]{xcolorschemes}
\newcommand{\ritem}[1]{#1 & {\color{#1}\rule{.5\textwidth}{1ex}}\\}
\begin{document}
'
make_tablehead
<xcolorschemes.sty sed -n '/definecolor/ s/^.*definecolor{\(.*\)}{\(.*\)}{\(.*\)}$/\\ritem{\1}/p;/DeclareOption/s/^.*$/\\hline/p'
make_tableend
echo '\end{document}'
} > "$o"

pdflatex "$o"
inkscape -f "$o.pdf" -e "$o.png"

rm -f "$o" *.aux *.log
