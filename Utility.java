public class Utility {
  double mutation_step;
  double linearRankingValue;
  double arithmeticCrossoverVal;
  int rankingType;
  int populationSize;
  int offspringNumber;
  int mutationChoice;

  public Utility() {
    mutation_step = 0.25; // betwen 0 and 1, if using uncorrelatedMut it changes
    linearRankingValue = 1.8; // between 1 and 2
    rankingType = 0; // if 0 linear ranking if 1 exponential ranking
    populationSize = 20; // pop size
    offspringNumber = 5; // offspring size
    arithmeticCrossoverVal = 0.5; // between 0 and 1
    mutationChoice = 1; // if 0 uniform mutation, if 1 nonuniform, if 2 uncorrelated
  }
}
