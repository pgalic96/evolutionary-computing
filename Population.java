import java.util.Random;

public class Population {

	Individual[] individuals;
	int populationSize;
	int offspringNumber;

	public Population(int n, Random rand, int offspringSize) {
		this.populationSize = n;
		this.individuals = new Individual[populationSize];
		this.offspringNumber = offspringSize;
		for (int i = 0; i < populationSize; i++) {
			this.individuals[i] = new Individual(rand);
		}
	}

	public Population(int n, int offspringSize) {
		populationSize = n;
		individuals = new Individual[populationSize];
		offspringNumber = offspringSize;
	}

	public Population(Population parent, Population children) {
		this.populationSize = parent.populationSize + children.populationSize;
		offspringNumber = 0;
		individuals = new Individual[populationSize];
		for (int i = 0; i < parent.populationSize; i++) {
			this.individuals[i] = new Individual(parent.individuals[i]);
		}
		for (int z = 0; z < children.populationSize; z++) {
			this.individuals[z+parent.populationSize] = new Individual(children.individuals[z]);
		}
	}

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

	//parent selection
	public void linearRanking(double s) {
		this.sortByFitness();
		double probability = 0.0;
		for (int i = 0; i < populationSize; i++) {
			probability = (2-s) + (2*(s-1)*i)/(populationSize-1);
			probability = probability/populationSize;
			this.individuals[i].setSelectionProbability(probability);
		}
	}

	public void exponentialRanking() {
		this.sortByFitness();
		double probability;
		for (int i = 0; i < populationSize;i++) {
			probability = (1 - Math.pow(Math.E, -(i+1)))/populationSize;
			this.individuals[i].setSelectionProbability(probability);
		}
	}

	//roulette wheel
	public Individual rouletteSelect(Random r) {
		double value = r.nextDouble();

		for (int i=0; i<populationSize; i++) {
			value = value - individuals[i].getSelectionProbability();
			if (value < 0) return individuals[i];
		}

		return individuals[populationSize-1];
	}


	public Individual uniformSelection(Random r) {
		int index = r.nextInt(populationSize);
		return individuals[index];
	}

	//survivor selection strategies

	public Population takeBest(Population children) {
		Population parentAndChildren = new Population(this, children);
		parentAndChildren.linearRanking(1.3);
		Population survivors = new Population(this.populationSize, this.offspringNumber);
		for (int i = 0; i < this.populationSize; i++) {
			survivors.individuals[i] = new Individual(parentAndChildren.individuals[parentAndChildren.populationSize-1-i]);
		}
		survivors.linearRanking(1.3);
		return survivors;
	}

	public Population rankAndRoulette(Population children, Random r) {
		Population parentAndChildren = new Population(this, children);
		parentAndChildren.linearRanking(1.5);
		Population survivors = new Population(this.populationSize, this.offspringNumber);
		for (int i = 0; i < this.populationSize; i++) {
			survivors.individuals[i] = parentAndChildren.rouletteSelect(r);
		}
		return survivors;
	}
}
