import java.util.Random;

public class Population {
	Individual[] individuals; // array of individuals, representing population.
	int populationSize;
	int offspringNumber;
	/**
	This is where Population is created
	n - population size
	rand - random number
	offspringSize - number of children
	step - mutation_step (learning rate)
	**/
	public Population(int n, Random rand, int offspringSize, double step) {
		this.populationSize = n;
		this.individuals = new Individual[populationSize];
		this.offspringNumber = offspringSize;
		for (int i = 0; i < populationSize; i++) {
			this.individuals[i] = new Individual(rand, step); //create individuals and add them to population
		}
	}

	/**
	This is where an empty population is created
	**/
	public Population(int n, int offspringSize) {
		populationSize = n;
		individuals = new Individual[populationSize];
		offspringNumber = offspringSize;
	}
	/**
	*This is where population is created out of parents and children, used for "plus" selection strategy
	**/
	public Population(Population parent, Population children) {
		this.populationSize = parent.populationSize + children.populationSize; //size of population is size of parent population + size of children population
		offspringNumber = 0; // number of offsprings is set to 0, since we dont need this parameter
		individuals = new Individual[populationSize]; // create a new array for the population
		for (int i = 0; i < parent.populationSize; i++) {
			this.individuals[i] = new Individual(parent.individuals[i]); //first we add all parents
		}
		for (int z = 0; z < children.populationSize; z++) {
			this.individuals[z+parent.populationSize] = new Individual(children.individuals[z]); // then we add all children
		}
	}
	// sort all individuals in population by fitness: first one has the least fitness and the last one is the most fit one
	public void sortByFitness() {
		for (int i = 0; i < populationSize-1; i++) {
			for (int j = 0; j < populationSize-i-1; j++) {
				if (this.individuals[j].getFitness() >
				this.individuals[j+1].getFitness()) {
					Individual temp = new Individual(individuals[j]);
					individuals[j] = individuals[j+1];
					individuals[j+1] = temp;
				}
			}
		}
	}


	/**
	If choice is 0, run linear ranking
	if choice is 1, run exponential ranking
	**/
	public void rank(int choice, double s) {
		if (choice == 0) {
			this.linearRanking(s);
		} else if (choice == 1) {
			this.exponentialRanking();
		}
	}


	public void linearRanking(double s) {
		//first sort by fitness
		this.sortByFitness();
		double probability = 0.0;
		for (int i = 0; i < populationSize; i++) { // go through all members of population, parameter i is their rank (first one 0, last one size -1)
			probability = (2-s) + (2*(s-1)*i)/(populationSize-1); //formula for calculating selection probability based on ranking i
			probability = probability/populationSize; //divide by population size such that we get number between 0 and 1
			this.individuals[i].setSelectionProbability(probability); // set probability for individual
		}
	}
	//parent selection by exponential ranking
	public void exponentialRanking() {
		this.sortByFitness(); // sort by fitness
		double probability;
		for (int i = 0; i < populationSize;i++) {
			probability = (1 - Math.pow(Math.E, -(i+1)))/populationSize; // formula for probability based on ranking
			this.individuals[i].setSelectionProbability(probability); // set probability
		}
	}

	//roulette wheel method
	public Individual rouletteSelect(Random r) {
		double value = r.nextDouble();
		for (int i=0; i<populationSize; i++) {
			value = value - individuals[i].getSelectionProbability();
			if (value < 0) return individuals[i];
		}

		return individuals[populationSize-1];
	}

	//uniform selection, just pick a random individual from the population
	public Individual uniformSelection(Random r) {
		int index = r.nextInt(populationSize);
		return individuals[index];
	}

	//survivor selection strategies


	//plus strategy, get all parents and children together and pick N best by fitness where N is population size of parent
	/**
	children - child population	**/
	public Population takeBest(Population children) {
		Population parentAndChildren = new Population(this, children);
		parentAndChildren.sortByFitness();
		Population survivors = new Population(this.populationSize, this.offspringNumber);
		for (int i = 0; i < this.populationSize; i++) {
			survivors.individuals[i] = new Individual(parentAndChildren.individuals[parentAndChildren.populationSize-1-i]);
		}
		return survivors;
	}

	//parent selection strategy applied to survivor selection, get all the parents and children together, rank them by linear/exponentialRanking
	/**
	children - children population
	r - random number
	choice - if 0 linear ranking, if 1 exponential
	s - value for linear ranking between 1 and 2
	**/
	public Population rankAndRoulette(Population children, Random r, int choice, double s) {
		Population parentAndChildren = new Population(this, children);
		parentAndChildren.rank(choice, s);
		Population survivors = new Population(this.populationSize, this.offspringNumber);
		for (int i = 0; i < this.populationSize; i++) {
			survivors.individuals[i] = parentAndChildren.rouletteSelect(r);
		}
		survivors.rank(choice, s);
		return survivors;
	}
}
