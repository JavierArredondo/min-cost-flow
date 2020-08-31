#!/bin/bash
ignore=(big1 big2 big3 big4 big5 big6 big7 big8)
files=(stndrd1 stndrd10 stndrd16 stndrd17 stndrd18 stndrd19 stndrd2 stndrd20 stndrd21 stndrd22 stndrd23 stndrd24 stndrd25 stndrd26 stndrd27 stndrd28 stndrd29 stndrd3 stndrd30 stndrd31 stndrd32 stndrd33 stndrd34 stndrd35 stndrd36 stndrd37 stndrd38 stndrd39 stndrd4 stndrd40 stndrd41 stndrd42 stndrd43 stndrd44 stndrd45 stndrd46 stndrd47 stndrd48 stndrd5 stndrd50 stndrd51 stndrd52 stndrd53 stndrd54 stndrd6 stndrd7 stndrd8 stndrd9)
for i in "${files[@]}";
	do 
			echo "$i";
			Rscript --vanilla run.R $i;
	done

