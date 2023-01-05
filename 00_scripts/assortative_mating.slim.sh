// set up a simple neutral simulation
initialize() {
	if (exists("slimgui"))
		{
			//defineConstant("seed", 1);
			defineConstant("mu", 1e-5);
			defineConstant("MigRate", 0.01);
			defineConstant("LocalAdaptForce", 1.0);
			defineConstant("AssortForce", 1.0);
			defineConstant("Rep", 1);
		}
	//setSeed(seed);
	// set the overall mutation rate
	initializeMutationRate(mu);
	// m1 mutation type: neutral
	initializeMutationType("m10", 0, "g", -0.03, 0.2); //mutation sampled among a gamma dsitribution
	initializeMutationType("m11", 0.001, "g", -0.03, 0.2);
	initializeMutationType("m12", 0.01, "g", -0.03, 0.2);
	initializeMutationType("m13", 0.1, "g", -0.03, 0.2);
	initializeMutationType("m14", 0.25, "g", -0.03, 0.2);
	initializeMutationType("m15", 0.5, "g", -0.03, 0.2);
	initializeMutationType("m16", 0.5, "f", 0); //Neutral mutation 
	initializeMutationType("m21", 1.0, "f", 0);// Wing pattern mutation 1 
	initializeMutationType("m22", 1.0, "f", 0);// Wing pattern mutation 2 
	initializeMutationType("m23", 1.0, "f", 0);// Wing pattern mutation 3 
	initializeMutationType("m24", 1.0, "f", 0);// Wing pattern mutation 4 
	initializeMutationType("m25", 1.0, "f", 0);// Wing pattern mutation 5 
	initializeMutationType("m31", 0.0, "f", -0.1);// A deleterious recessive mutation 
	initializeMutationType("m32", 0.0, "f", -0.1);// A deleterious recessive mutation 
	initializeMutationType("m33", 0.0, "f", -0.1);// A deleterious recessive mutation 
	initializeMutationType("m34", 0.0, "f", -0.1);// A deleterious recessive mutation 
	initializeMutationType("m35", 0.0, "f", -0.1);// A deleterious recessive mutation 
	// g1 genomic element type: uses m1 for all mutations 
	initializeGenomicElementType("g1", c(m10,m11,m12,m13,m14,m15, m16),c(1,1,1,1,1,1,16)); //mutation with different dominance appear with different probability
	// uniform chromosome of length 10Mb for two chromosome
	initializeGenomicElement(g1, 0,999999);
	// uniform recombination along two chromosomes
	rates=c(5e-06);//Two chromosomes with R=r	
	ends=c(999999); //One chromosome of size 10000000	
	initializeRecombinationRate(rates, ends);
	initializeSex("A");
	//defineConstant("InvArray",matrix(c(1,1,1), nrow=1));
}
// create a population of 500 individuals
1 late(){
	defineConstant("simID", getSeed());
	subpopCount = 10;
	//#for (i in 1:subpopCount)
	//#     sim.addSubpop(i, 1000);

        sim.addSubpop("p1", 1000);
        sim.addSubpop("p2", 1000);
        sim.addSubpop("p3", 1000);
        sim.addSubpop("p4", 1000);
        sim.addSubpop("p5", 1000);
        sim.addSubpop("p6", 1000);
        sim.addSubpop("p7", 1000);
        sim.addSubpop("p8", 1000);
        sim.addSubpop("p9", 1000);
        sim.addSubpop("p10", 1000);


	Sample=sample(sim.subpopulations.genomes, 4000);// sample one individual and introduce the inversion and the mutation locus
	Sample.addNewDrawnMutation(m21, 100000); //Color locus mutation
	Sample.addNewDrawnMutation(m31, 100001); //Deleterious mutation making the color locus mutation overdominant
	VecMut=sim.subpopulations.genomes.containsMarkerMutation(m21,100000);//vector of boolean depending on whether genome that contain the inversion
	SubPop=sim.subpopulations.genomes[!VecMut];
	Sample2=sample(SubPop, 4000);
	Sample2.addNewDrawnMutation(m22, 100000); //
	Sample2.addNewDrawnMutation(m32, 100001); //
	VecMut=SubPop.containsMarkerMutation(m22,100000);//vector of boolean depending on whether genome that contain the inversion
	SubPop=SubPop[!VecMut];
	Sample3=sample(SubPop, 4000);
	Sample3.addNewDrawnMutation(m23, 100000); //
	Sample3.addNewDrawnMutation(m33, 100001); //
	VecMut=SubPop.containsMarkerMutation(m23,100000);//vector of boolean depending on whether genome that contain the inversionfor (i in 1:subpopCount)
	SubPop=SubPop[!VecMut];
	Sample4=sample(SubPop, 4000);
	Sample4.addNewDrawnMutation(m24, 100000); //
	Sample4.addNewDrawnMutation(m34, 100001); //
	VecMut=SubPop.containsMarkerMutation(m24,100000);//vector of boolean depending on whether genome that contain the inversionfor (i in 1:subpopCount)
	SubPop=SubPop[!VecMut];
	Sample5=sample(SubPop, 4000);
	Sample5.addNewDrawnMutation(m25, 100000); //
	Sample5.addNewDrawnMutation(m35, 100001); //
		
	for (i in 1:subpopCount)
		for (j in 1:subpopCount)
			if (i != j)
				sim.subpopulations[i-1].setMigrationRates(j, MigRate);
	}

1: late(){
	for (g in sim.subpopulations.individuals)
		{
		if (any(g.genomes.containsMarkerMutation(m21,100000)))
			{g.tag=1;}
		else
			{if(any(g.genomes.containsMarkerMutation(m22,100000)))
				{g.tag=2;}
			else
				{if(any(g.genomes.containsMarkerMutation(m23,100000)))
					{g.tag=3;}
				else
					{if(any(g.genomes.containsMarkerMutation(m24,100000)))
						{g.tag=4;}
					else
						{g.tag=5;}
					}
				}
			}
		}
	}
fitness(NULL,p1) { 
	if(individual.tag==1)
		return 1.0;
	else if(individual.tag==2)
		return 1.0;
	else if(individual.tag==3)
		return 1.0;
	else if(individual.tag==4)
		return LocalAdaptForce;
	else if(individual.tag==5)
		return LocalAdaptForce; 
	}
		
fitness(NULL,p2) { 
	if(individual.tag==1)
		return 1.0;
	else if(individual.tag==2)
		return LocalAdaptForce;
	else if(individual.tag==3)
		return LocalAdaptForce;
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return LocalAdaptForce; 
	}

fitness(NULL,p3) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return LocalAdaptForce;
	else if(individual.tag==3)
		return 1.0;
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return 1.0;
	}

fitness(NULL,p4) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return 1.0;
	else if(individual.tag==3)
		return LocalAdaptForce;
	else if(individual.tag==4)
		return LocalAdaptForce;
	else if(individual.tag==5)
		return 1.0;
	}

fitness(NULL,p5) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return LocalAdaptForce;
	else if(individual.tag==3)
		return 1.0;
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return LocalAdaptForce; 
	}

fitness(NULL,p6) { 
	if(individual.tag==1)
		return 1.0;
	else if(individual.tag==2)
		return LocalAdaptForce; 
	else if(individual.tag==3)
		return LocalAdaptForce; 
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return 1.0;
	}

fitness(NULL,p7) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return LocalAdaptForce;
	else if(individual.tag==3)
		return 1.0;
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return 1.0;
	}

fitness(NULL,p8) { 
	if(individual.tag==1)
		return 1.0;
	else if(individual.tag==2)
		return LocalAdaptForce;
	else if(individual.tag==3)
		return LocalAdaptForce;
	else if(individual.tag==4)
		return LocalAdaptForce;
	else if(individual.tag==5)
		return 1.0;
	}

fitness(NULL,p9) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return 1.0;
	else if(individual.tag==3)
		return LocalAdaptForce;
	else if(individual.tag==4)
		return LocalAdaptForce;
	else if(individual.tag==5)
		return 1.0;
	}
	
fitness(NULL,p10) { 
	if(individual.tag==1)
		return LocalAdaptForce;
	else if(individual.tag==2)
		return 1.0;
	else if(individual.tag==3)
		return 1.0;
	else if(individual.tag==4)
		return 1.0;
	else if(individual.tag==5)
		return LocalAdaptForce; 
	}
		
1: mateChoice() {
Parent2SimilarPheno= (sourceSubpop.individuals.tag == individual.tag);
//##return weights * ifelse(Parent2SimilarPheno, AssortForce, 1.0);
return weights * ifelse(Parent2SimilarPheno, 1.0, AssortForce);
}

1: late(){
	if (sim.generation % 1000 == 1) //output every 100 generation for plottting
		{
		Genomes=p1.genomes; // All genomes
		NMutVec1=c();
		for (g in Genomes) { //For all genome // Far from being optimized...
			NbMut=g.countOfMutationsOfType(m16);
			NMutVec1=c(NMutVec1, NbMut);
			}
		Genomes=p5.genomes; // All genomes
		NMutVec5=c();
		for (g in Genomes) { //For all genome // Far from being optimized...
			NbMut=g.countOfMutationsOfType(m16);
			NMutVec5=c(NMutVec5, NbMut);
			}
		Genomes=p10.genomes; // All genomes
		NMutVec10=c();
		for (g in Genomes) { //For all genome // Far from being optimized...
			NbMut=g.countOfMutationsOfType(m16);
			NMutVec10=c(NMutVec1, NbMut);
			}
		meanNbMut1=mean(NMutVec1);//Mean number of mutation in genomes
		meanNbMut5=mean(NMutVec5);//Mean number of mutation in genomes
		meanNbMut10=mean(NMutVec10);//Mean number of mutation in genomes
		NmutS= sim.countOfMutationsOfType(m16); //number of mutations
		mutS = sim.mutationsOfType(m16);
		FreqS=sim.mutationFrequencies(NULL, mutS); 
		MeanFreqS=mean(FreqS); //Mean frequency of mutations
		PiTotal=0.0;
		PiTotal_S=0.0;
		for (ind in p1.individuals)
			{
			// Calculate the nucleotide heterozygosity of this individual
			muts0 = ind.genomes[0].mutations;
			muts1 = ind.genomes[1].mutations;
			muts0_S = ind.genomes[0].mutationsOfType(m16); //Only neutral mutation
			muts1_S = ind.genomes[1].mutationsOfType(m16);
			// Count the shared mutations
			shared_count = sum(match(muts0, muts1) >= 0);
			shared_count_S = sum(match(muts0_S, muts1_S) >= 0); //Only Neutral mutation
			// All remaining mutations are unshared (i.e. heterozygous)
			unshared_count = muts0.size() + muts1.size() - 2 * shared_count;
			unshared_count_S = muts0_S.size() + muts1_S.size() - 2 * shared_count_S;
			// pi is the mean heterozygosity across the chromosome
			pi_ind = unshared_count / (sim.chromosome.lastPosition + 1);
			pi_ind_S = unshared_count_S / (sim.chromosome.lastPosition + 1);
			PiTotal = PiTotal + pi_ind;
			PiTotal_S = PiTotal_S + pi_ind_S;
		}
		pi = PiTotal / p1.individuals.size();
		pi_S = PiTotal_S / p1.individuals.size();
		line=paste(c(mu,"\t",MigRate,"\t",AssortForce,"\t",LocalAdaptForce,"\t",Rep,"\t",simID,"\t",sim.generation,"\t", meanNbMut1,"\t", meanNbMut5,"\t", meanNbMut10,"\t", NmutS, "\t", MeanFreqS, "\t", pi, "\t", pi_S));
		//output the frequency of a given mutation
		writeFile(paste(c("Polymorphism_MateChoice_100KGen_Stat.txt"), sep=""), line, append=T);
		}
	}

100000 late(){
sim.outputFull(paste(c("Corrected_Polymorphism_MateChoice_100KGen_", simID,"_g25000_FullPop.txt"), sep=""));
sim.simulationFinished();
}
