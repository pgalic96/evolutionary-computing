import java.util.Random;

public class Individual {

	double vector[];
	private double fitness;
	private double mutation_step = 0.25;
	private double selectionProbability;

	//constructor for Individual: random values
	public Individual (Random rand) {
		this.vector = new double[10];
		this.fitness = 0.0;
		this.selectionProbability = 0.0;
		for (int i=0; i < this.vector.length; i++) {
			this.vector[i] = generateRandom(rand.nextDouble());
		}

	}

	public Individual (Individual parent) {
		this.vector = new double[10];
		for (int i = 0; i < 10; i++) {
			this.vector[i] = parent.vector[i];
		}
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

	public void uniformMut(Random r) {
		for (int i = 0; i < this.vector.length; i++) {
			double chance = r.nextDouble();
			if (chance < mutation_step) {
				this.vector[i] = generateRandom(r.nextDouble());
			}
		}
	}

	public void nonUniformMut(Random r) {
			for (int i = 0; i < this.vector.length; i++) {
					this.vector[i] += mutation_step * r.nextGaussian();
					// make sure the values stay within the bounds
					this.vector[i] = restrictBound(this.vector[i]);
			}
	}

	public void uncorrelatedMut(Random r) {
		this.mutation_step = Math.max(0.0,
		this.mutation_step * Math.exp((1/Math.sqrt(10))*r.nextGaussian()));
		for(int i = 0; i < this.vector.length; i++) {
			this.vector[i]+=this.mutation_step*r.nextGaussian();

			this.vector[i] = restrictBound(this.vector[i]);
		}
	}

	private double restrictBound(double n) {
		if (n < -5.0) {
			return -5.0;
		} else if (n > 5.0){
			return 5.0;
		} else {
			return n;
		}
	}

	//Crossover operators
	public Individual wholeArithmeticCrossover(Individual parent) {
		Individual child = new Individual(this);
		for (int i = 0; i < 10; i++) {
			child.vector[i] = (this.vector[i] + parent.vector[i])/2;
		}
		return child;
	}

	//se
	//generate a random number between -5 and 5
	private double generateRandom(double value) {
		return value * 10 - 5;
	}
}
