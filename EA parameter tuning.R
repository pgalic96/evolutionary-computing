library(dplyr)
library(dunn.test)

as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}
# Creathe dataframe with all possible parameter combinations and write it to a txt file
SearchSpace = expand.grid(mutation_step = seq(0.1,1,0.3), LinearRankingValue = seq(1, 2, 1/3), rankingType = c(0,1), populationSize = c(20,40,100,200),offspring = c(0.25,0.5,1),crossOverVal = seq(0,0.5,0.25),mutationChoice = c(0,1,2))
SearchSpace = SearchSpace[-which(SearchSpace$rankingType == 1 & SearchSpace$LinearRankingValue != 1),]
SearchSpace = mutate(SearchSpace,offspring = populationSize*offspring)
# Add a variable that shows progress in percentage (also used later to identify unique parameter combinations)
SearchSpace = mutate(SearchSpace, progress = 100*(1:nrow(SearchSpace))/nrow(SearchSpace))
write.table(SearchSpace,file = "C:/Users/Jan Haenen/Desktop/assignmentfiles_2018 (1)/assignmentfiles_2017/SchaffersFirstIter.txt",row.names = FALSE, col.names = FALSE)

# Alter the searchspace dataframe to match the output file (each parameter combination is run 5 times)
SolutionSpace = slice(SearchSpace,rep(1:n(), each = 5))

# Read output and merge with dataframe containing parameter values
Results = read.delim("C:/Users/Jan Haenen/Desktop/assignmentfiles_2018 (1)/assignmentfiles_2017/SchaffersFirstOutput.txt", sep = " ", header = FALSE)
Results2 = Results[which(Results$V1 == "Score:"),]
SolutionSpace = mutate(SolutionSpace, result = as.numeric.factor(Results2$V2))

# find best solution and determine which solutions are not significantly worse than the best solution
summary = summarise(group_by(SolutionSpace,progress),result = mean(result))
BestSolutionIdentifier = as.numeric(summary[which(summary$result == max(summary$result)),1])
BestSolutionResults = SolutionSpace[SolutionSpace$progress == BestSolutionIdentifier,]$result

summary = summarise(group_by(SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,BestSolutionResults),rep(1:2,each = 5))$P)

# create new search space containing best solution and solutions that are not significantly worse than best solution
S.SearchSpaceTWo = select(filter(summary,P>0.05),-progress,-P)
S.SearchSpaceTWo = mutate(S.SearchSpaceTWo, progress = 100*(1:nrow(S.SearchSpaceTWo))/nrow(S.SearchSpaceTWo))
write.table(S.SearchSpaceTWo,file = "C:/Users/Jan Haenen/Desktop/assignmentfiles_2018 (1)/assignmentfiles_2017/SchaffersSecondIter.txt",row.names = FALSE, col.names = FALSE)
