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

        // initialize population with random values, last parameter is learning rate
				Utility utility = new Utility();
        Population population = new Population(utility.populationSize, rnd_, utility.offspringNumber, utility.mutation_step);

        // calculate fitness for initial population
        for (int i = 0; i < population.populationSize; i++) {
        	population.individuals[i].setFitness((double)evaluation_.evaluate(population.individuals[i].vector));

					evals++;
        }

        while(evals<evaluations_limit_){
					//rank population, if 0 it means linear ranking, if 1 it means exponential, second parameter must be kept
					population.rank(utility.rankingType, utility.linearRankingValue);
					//create empty population of children with size defined in parent
        	Population childPopulation = new Population(population.offspringNumber, 0);
        	int currentOffspring = 0;
					int offspringnumber = population.offspringNumber;
					//begin selection/crossover/mutation
        	while (offspringnumber != 0) {
						//select parents by roulette wheel based on linear/exponential ranking
        		Individual parent1 = new Individual(population.rouletteSelect(rnd_));
        		Individual parent2 = new Individual(population.rouletteSelect(rnd_));

						//whole arithmetic crossover with alpha between 0 and 1
						childPopulation.individuals[currentOffspring] =new Individual(parent1.wholeArithmeticCrossover(parent2, utility.arithmeticCrossoverVal));

						//mutation (nonUniform, Uniform, uncorrelated)
						childPopulation.individuals[currentOffspring].mutate(utility.mutationChoice, rnd_);

						//evaluate the child after crossover and mutation
						childPopulation.individuals[currentOffspring].setFitness((double)evaluation_.evaluate(childPopulation.individuals[currentOffspring].vector));
						evals++;

						currentOffspring++; // go to next offspring
        		offspringnumber-=1;
        	}

            // Select survivors (rank and roulette or take best) last 2 parameters are used for linear/exponential ranking
            population = population.rankAndRoulette(childPopulation,  rnd_,utility.rankingType,  utility.linearRankingValue);
        }
	}
}
