#!/bin/bash
ignore=(big1 big2 big3 big4 big5 big6 big7 big8)
files=(cap40 cap41 cap5 cap7 cap8 cap9 stndrd1 stndrd10 stndrd16 stndrd17 stndrd18 stndrd19 stndrd2 stndrd20 stndrd21 stndrd22 stndrd23 stndrd24 stndrd25 stndrd26 stndrd27 stndrd28 stndrd29 stndrd3 stndrd30 stndrd31 stndrd32 stndrd33 stndrd34 stndrd35 stndrd36 stndrd37 stndrd38 stndrd39)
for i in "${files[@]}";
	do 
			echo "$i";
			Rscript --vanilla run.R $i;
	done

