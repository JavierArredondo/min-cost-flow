#!/bin/bash
ignore=(big1 big2 big3 big4 big5 big6 big7 big8)
files=(cap1 cap10 cap11 cap12 cap13 cap14 cap15 cap16 cap17 cap18 cap19 cap2 cap20 cap21 cap22 cap23 cap24 cap25 cap26 cap27 cap28 cap29 cap3 cap30 cap31 cap32 cap33 cap34 cap35 cap36 cap37 cap38 cap39 cap4)
for i in "${files[@]}";
	do 
			echo "$i";
			Rscript --vanilla run.R $i;
	done

