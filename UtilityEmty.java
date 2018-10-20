public class Utility {
  double mutation_step;
  double linearRankingValue;
  double arithmeticCrossoverVal;
  int rankingType;
  int populationSize;
  int offspringNumber;
  int mutationChoice;

  public Utility() {
    mutation_step =; // betwen 0 and 1, if using uncorrelatedMut it changes
    linearRankingValue =; // between 1 and 2
    rankingType =; // if 0 linear ranking if 1 exponential ranking
    populationSize =; // pop size
    offspringNumber =; // offspring size
    arithmeticCrossoverVal =; // between 0 and 1
    mutationChoice =; // if 0 uniform mutation, if 1 nonuniform, if 2 uncorrelated
  }
}
