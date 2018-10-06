import java.util.Random;

public class Individual {
	
	public double vector[];
	private double fitness;
	
	public Individual (Random rand) {
		this.vector = new double[10];
		this.fitness = 0.0;
		for (int i=0; i < this.vector.length; i++) {
			this.vector[i] = generateRandom(rand.nextDouble());
		}
		
	}
	
	private double generateRandom(double value) {
		return value * 10 - 5;
	}
}
