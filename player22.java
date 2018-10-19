import org.vu.contest.ContestSubmission;
import org.vu.contest.ContestEvaluation;

import java.util.Random;
import java.util.Properties;

public class player22 implements ContestSubmission
{
	Random rnd_;
	ContestEvaluation evaluation_;
    private int evaluations_limit_;

	public player22()
	{
		rnd_ = new Random();
	}

	public void setSeed(long seed)
	{
		// Set seed of algortihms random process
		rnd_.setSeed(seed);
	}

	public void setEvaluation(ContestEvaluation evaluation)
	{
		// Set evaluation problem used in the run
		evaluation_ = evaluation;

		// Get evaluation properties
		Properties props = evaluation.getProperties();
        // Get evaluation limit
        evaluations_limit_ = Integer.parseInt(props.getProperty("Evaluations"));
		// Property keys depend on specific evaluation
		// E.g. double param = Double.parseDouble(props.getProperty("property_name"));
        boolean isMultimodal = Boolean.parseBoolean(props.getProperty("Multimodal"));
        boolean hasStructure = Boolean.parseBoolean(props.getProperty("Regular"));
        boolean isSeparable = Boolean.parseBoolean(props.getProperty("Separable"));

		// Do sth with property values, e.g. specify relevant settings of your algorithm
        if(isMultimodal){
            // Do sth
        }else{
            // Do sth else
        }
    }

	public void run()
	{
		// Run your algorithm here
        int evals = 0;

        // init population
        Population population = new Population(20, rnd_, 20);

        // calculate fitness
        for (int i = 0; i < population.populationSize; i++) {
        	population.individuals[i].setFitness((double)evaluation_.evaluate(population.individuals[i].vector));

					evals++;
        }

				//population.linearRanking(1.5);

        while(evals<evaluations_limit_){
            // Select parents
        	int offspringnumber = population.offspringNumber;
        	Population childPopulation = new Population(offspringnumber, 0);
        	int currentOffspring = 0;
        	while (offspringnumber != 0) {
        		Individual parent1 = new Individual(population.rouletteSelect(rnd_));
        		Individual parent2 = new Individual(population.rouletteSelect(rnd_));

						//crossover
						childPopulation.individuals[currentOffspring] =new Individual(parent1.wholeArithmeticCrossover(parent2));
						childPopulation.individuals[currentOffspring].nonUniformMut(rnd_);
						//evaluate
						childPopulation.individuals[currentOffspring].setFitness((double)evaluation_.evaluate(childPopulation.individuals[currentOffspring].vector));
						evals++;
						currentOffspring++;
        		offspringnumber-=1;
        	}



            // Apply crossover / mutation operators
            // Check fitness of unknown function
            //for (int z = 0; z < childPopulation.populationSize; z++) {
            //	childPopulation.individuals[z].setFitness((double)evaluation_.evaluate(childPopulation.individuals[z].vector));
						//	evals++;
						//}
						//double previousEval = population.individuals[0].getFitness();
						//population.individuals[0].nonUniformMut(rnd_);
						//population.individuals[0].setFitness((double)evaluation_.evaluate(population.individuals[0].vector));
						//System.out.println(population.individuals[0].getFitness());
						//evals++;
						//population = population.takeBest(childPopulation);
						// if (childPopulation.individuals[0].getFitness() > population.individuals[0].getFitness()) {
						// 	for (int i =0; i < 10; i++) {
						// 		System.out.println(i + "  parent: " + population.individuals[0].vector[i] + " ---- child: " +childPopulation.individuals[0].vector[i]);
						// 	}
						// }
            // Select survivors
            population = population.takeBest(childPopulation);
        }
	}
}
