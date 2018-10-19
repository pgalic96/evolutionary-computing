import java.util.Random;

public class Individual {

	double vector[];
	private double fitness;
	private double mutation_step;
	private double selectionProbability;

	//constructor for Individual: random values
	public Individual (Random rand, double step) {
		this.vector = new double[10];
		this.fitness = 0.0;
		this.selectionProbability = 0.0;
		this.mutation_step = step;
		for (int i=0; i < this.vector.length; i++) {
			this.vector[i] = generateRandom(rand.nextDouble());
		}

	}
	//constructor for Individual that inherits all parameters from the parent
	public Individual (Individual parent) {
		this.vector = new double[10];
		for (int i = 0; i < 10; i++) {
			this.vector[i] = parent.vector[i];
		}
		mutation_step = parent.mutation_step;
		this.fitness = parent.fitness;
		this.selectionProbability = parent.selectionProbability;
	}

	// Get Fitness
	public double getFitness() {
		return fitness;
	}
	// Set Fitness
	public void setFitness(double evaluation) {
		this.fitness = evaluation;
	}
	//get selection probability
	public double getSelectionProbability() {
		return selectionProbability;
	}

	//set selection probability
	public void setSelectionProbability(double prob) {
		selectionProbability = prob;
	}

	//Mutations
	public void mutate(int choice, Random r) {
		if (choice == 0) {
			this.uniformMut(r);
		} else if(choice == 1) {
			this.nonUniformMut(r);
		} else if (choice == 2) {
			this.uncorrelatedMut(r);
		}
	}
	/**
	Uniform mutation, take a random value and if its smaller than learning rate,
	generate a random number for one value of vector
	**/
	public void uniformMut(Random r) {
		for (int i = 0; i < this.vector.length; i++) {
			double chance = r.nextDouble();
			if (chance < mutation_step) {
				this.vector[i] = generateRandom(r.nextDouble());
			}
		}
	}

	/**
	non uniform mutation
	increment each vector value by mutation step * normally distributed random number
	**/
	public void nonUniformMut(Random r) {
			//go through all values of the vector
			for (int i = 0; i < this.vector.length; i++) {
					//increment the vector value
					this.vector[i] += mutation_step * r.nextGaussian();
					// make sure the values stay within the bounds
					if (this.vector[i] > 5.0) {
						this.vector[i] = 5.0;
					} else if (this.vector[i]< -5.0) {
						this.vector[i] = -5.0;
					}
			}
	}

	//uncorrelated mutation, not sure if it works, if someone can check please do
	public void uncorrelatedMut(Random r) {
		this.mutation_step = Math.max(0.0,
		this.mutation_step * Math.exp((1/Math.sqrt(10))*r.nextGaussian()));
		for(int i = 0; i < this.vector.length; i++) {
			this.vector[i]+=this.mutation_step*r.nextGaussian();
			if (this.vector[i] > 5.0) {
				this.vector[i] = 5.0;
			} else if (this.vector[i]< -5.0) {
				this.vector[i] = -5.0;
			}
		}
	}

	//Crossover operators
	public Individual wholeArithmeticCrossover(Individual parent, double alpha) {
		Individual child = new Individual(this);
		for (int i = 0; i < 10; i++) {
			child.vector[i] = alpha * this.vector[i] + (1-alpha)*parent.vector[i];
		}
		return child;
	}

	//se
	//generate a random number between -5 and 5
	private double generateRandom(double value) {
		return value * 10 - 5;
	}
}
