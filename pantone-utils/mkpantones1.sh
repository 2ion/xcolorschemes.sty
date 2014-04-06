cat pantones0.txt | sed s/^PMS(S+)s*(S+)$/\definecolor{P1}{cmyk}{2}/ > pantones1.txt
