#!/bin/bash
ignore=(big1 big2 big3 big4 big5 big6 big7 big8)
files=(cap1 cap10 cap11 cap12 cap13 cap14 cap15 cap16 cap17 cap18 cap19 cap2 cap20 cap21 cap22 cap23 cap24 cap25 cap26 cap27 cap28 cap29 cap3 cap30 cap31 cap32 cap33 cap34 cap35 cap36 cap37 cap38 cap39 cap4 cap40 cap41 cap5 cap7 cap8 cap9 stndrd1 stndrd10 stndrd16 stndrd17 stndrd18 stndrd19 stndrd2 stndrd20 stndrd21 stndrd22 stndrd23 stndrd24 stndrd25 stndrd26 stndrd27 stndrd28 stndrd29 stndrd3 stndrd30 stndrd31 stndrd32 stndrd33 stndrd34 stndrd35 stndrd36 stndrd37 stndrd38 stndrd39 stndrd4 stndrd40 stndrd41 stndrd42 stndrd43 stndrd44 stndrd45 stndrd46 stndrd47 stndrd48 stndrd5 stndrd50 stndrd51 stndrd52 stndrd53 stndrd54 stndrd6 stndrd7 stndrd8 stndrd9 transp1 transp10 transp11 transp12 transp13 transp14 transp2 transp3 transp4 transp5 transp6 transp7 transp8 transp9)

for i in "${files[@]}";
	do 
			echo "$i";
			Rscript --vanilla run.R $i;
	done

