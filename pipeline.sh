
for mig in 1e-4 1e-6 1e-8 ; do 
	for AF in 0.0 0.25 0.5 ; do 
		for LF in 0.0 0.25 0.5 ; do 
			echo -e " sbatch submit_array_asortative_mating.sh ${mig} ${AF} ${LF} " ; 
		done ; 
	done  ; 
done

#then submit these job

#then do the same with assortative job 

for mig in 1e-4 1e-6 1e-8 ; do 
	for AF in 0.0 0.25 0.5 ; do 
		for LF in 0.0 0.25 0.5 ; do 
			echo -e " sbatch submit_array_disasortative_mating.sh ${mig} ${AF} ${LF} " ; 
		done ; 
	done  ; 
done


