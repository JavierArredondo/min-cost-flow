#!/bin/bash
ignore=(big1 big2 big3 big4 big5 big6 big7 big8)
files=(stndrd4 stndrd40 stndrd41 stndrd42 stndrd43 stndrd44 stndrd45 stndrd46 stndrd47 stndrd48 stndrd5 stndrd50 stndrd51 stndrd52 stndrd53 stndrd54 stndrd6 stndrd7 stndrd8 stndrd9 transp1 transp10 transp11 transp12 transp13 transp14 transp2 transp3 transp4 transp5 transp6 transp7 transp8 transp9)
for i in "${files[@]}";
	do 
			echo "$i";
			Rscript --vanilla run.R $i;
	done

