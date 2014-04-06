#!/bin/bash
# vim: set tw=0

echo "xcolorschemes.sty LaTeX package - colortable generator"
echo "------------------------------------------------------"

deps=(pdftocairo pdflatex)
depfail=0
for d in ${deps[@]} ; do
  if ! type $d &>/dev/null ; then
    echo "Error: missing dependency: $d"
    depfail=1
  fi
done
if (( $depfail == 1)) ; then
  echo "Can't run because of missing dependencies."
  echo "------------------------------------------------------"
  exit 1
fi

o=colortable

make_tablehead(){
  echo '\begin{tabular}{>{\ttfamily}ll>{\ttfamily}l}
  \toprule Name & & Color definition\\\otoprule'
}

make_tableend(){
  echo '\bottomrule\end{tabular}'
}

echo -n "Generating LaTeX input from xcolorschemes.sty ... "

{
  echo '
\documentclass[border=1cm]{standalone}
\usepackage{array}
\usepackage{booktabs}
\usepackage{tabularx}
\newcommand{\otoprule}{\midrule[\heavyrulewidth]}
\usepackage[all]{xcolorschemes}
\newcommand{\ritem}[2]{#1 & {\color{#1}\rule{.5\textwidth}{1ex}} & \##2\\}
\begin{document}'
make_tablehead
<xcolorschemes.sty sed -n '/definecolor/s/^.*definecolor{\(.*\)}{\(.*\)}{\(.*\)}$/\\ritem{\1}{\3}/p;/DeclareOption/s/^.*$/\\midrule/p'
make_tableend
echo '\end{document}'
} > "$o"

echo "OK"

echo -n "Running pdfLaTeX ... "

if ! pdflatex "$o" &>/dev/null ; then
  echo FAILED
  exit 1
else
  echo OK
fi

echo -n "Creating the PNG image from the PDF document ... "

if pdftocairo -singlefile -png "$o.pdf" ; then
  echo OK
else
  echo FAILED
  exit 1
fi

echo -n "Cleaning up ... "

rm -f "$o" *.aux *.log && echo OK || echo FAILED

echo "Done."
echo "------------------------------------------------------"
exit 0
