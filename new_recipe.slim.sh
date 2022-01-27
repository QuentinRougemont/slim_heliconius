// Keywords: gene interaction
//assumption for genomics:
//mutation rate from Keightley et al: µ= 2.9 × 10−9
//assumed inital r = 1e-08 and rescaled using 1/2*(1-(1-2r)^n)
//assumed Nc = 1e6
//rescale all by a factor of 100
//Size of supergene ~1.5mb on ~300mb so we rescale to a 5kb locus on a 1mb block 

initialize() {
	initializeMutationRate(2.9e-7);   //µ is recsaled 
	initializeMutationType("m1", 0.5, "f", 0.0);
  	initializeMutationType("m2", 0.5, "f", 0.0);  // mutation A
        //introduce deleterious mutations:	
	initializeMutationType("m3", 0,   "g", -0.05, 0.5); // Deleterious mutation with a gamma distribution of fitness effect (alpha = 0.5 and beta =10). V
	//initializeMutationType("m2", 0.5, "f", 0.5);  // mutation A
	//m2.convertToSubstitution = F;
	//initializeMutationType("m3", 0.5, "f", 0.5);  // mutation B
	//m3.convertToSubstitution = F;
	//initializeMutationType("m4", 0.5, "f", 0.5);  // mutation C
	//m4.convertToSubstitution = F;
	initializeGenomicElementType("g1", m1, 1.0);
	initializeGenomicElementType("g2", m2, 1.0);
	initializeGenomicElement(g1, 0, 99999);
	initializeGenomicElement(g2, 100000, 110000);
	initializeGenomicElement(g1, 110001, 999999);

	initializeRecombinationRate(9.99999e-07); //also rescaled.
}
1 {
	subpopCount = 5; 
	for (i in 1:subpopCount)
	sim.addSubpop(i, 500); //this will be increased to 10,000 to reflect a Nc of 1e6.
	for (i in 2:subpopCount)
	sim.subpopulations[i-1].setMigrationRates(i-1, 0.01);
	for (i in 1:(subpopCount-1))
	sim.subpopulations[i-1].setMigrationRates(i+1, 0.01);

}
//100 late() {
	//sample(p1.genomes, 20).addNewDrawnMutation(m2, 10000);  // add A
	//sample(p3.genomes, 20).addNewDrawnMutation(m3, 12000);  // add B
	//sample(p5.genomes, 20).addNewDrawnMutation(m4, 14000);  // add C
   //Do we want a mutation that is sampled in one pop to be deleterious in another as well? or only deleterious when homozygous?
   
//}
10000 late() {
	cat("m1 mutation count: " + sim.countOfMutationsOfType(m1) + "\n");
	cat("m2 mutation count: " + sim.countOfMutationsOfType(m2) + "\n");

	pi1 = calcHeterozygosity(p1.genomes);
	pi2 = calcHeterozygosity(p2.genomes);
	pi3 = calcHeterozygosity(p3.genomes);
	pi4 = calcHeterozygosity(p4.genomes);
	pi5 = calcHeterozygosity(p5.genomes);

	cat("pi1 :" +  pi1 + "\n" );
	cat("pi2 :" +  pi2 + "\n" );
	cat("pi3 :" +  pi3 + "\n" );
	cat("pi4 :" +  pi4 + "\n" );
	cat("pi5 :" +  pi5 + "\n" );

//sample individuals to produce a vcf
pop1=sample(p1.individuals,5,F);
pop2=sample(p2.individuals,5,F);
pop3=sample(p3.individuals,5,F);
pop4=sample(p4.individuals,5,F);
combined=c(pop2,pop1,pop3,pop4); 
combined.genomes.outputVCF(filePath="pouet.vcf",outputMultiallelics=T);
}

//here's the important bits that will make die with a 99% probability those individuals that are homozygous.
modifyChild() {
	Muts = childGenome2.mutationsOfType(m2);
	Muts1 = parent1Genome1.mutationsOfType(m2);
	Muts2 = parent1Genome2.mutationsOfType(m2);
	if (identical(Muts, Muts1))
		if (runif(1) < 0.99)
			return F;
	if (identical(Muts, Muts2))
		if (runif(1) < 0.99)
			return F;
	return T;
}