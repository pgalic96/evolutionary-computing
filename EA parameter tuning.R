library(dplyr)
library(dunn.test)
as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}
setwd("C:/Users/Jan Haenen/Desktop/assignmentfiles_2018 (1)/assignmentfiles_2017/")


##############################
#First Iteration Search Space#
##############################
# Creathe dataframe with all possible parameter combinations and write it to a txt file
SearchSpace = expand.grid(mutation_step = seq(0.1,1,0.3), LinearRankingValue = seq(1, 2, 1/3), rankingType = c(0,1), populationSize = c(20,40,100,200),offspring = c(0.25,0.5,1),crossOverVal = seq(0,0.5,0.25),mutationChoice = c(0,1,2))
SearchSpace = SearchSpace[-which(SearchSpace$rankingType == 1 & SearchSpace$LinearRankingValue != 1),]
SearchSpace = mutate(SearchSpace,offspring = populationSize*offspring)
# Add a variable that shows progress in percentage (also used later to identify unique parameter combinations)
SearchSpace = mutate(SearchSpace, progress = 100*(1:nrow(SearchSpace))/nrow(SearchSpace))
write.table(SearchSpace,file = "FirstIter.txt",row.names = FALSE, col.names = FALSE)

# Alter the searchspace dataframe to match the output file (each parameter combination is run 5 times)
SolutionSpace = slice(SearchSpace,rep(1:n(), each = 5))

## Bent Cigar smaller due to time constraints
B.SearchSpace = expand.grid(mutation_step = seq(0.4,1,0.3), LinearRankingValue = seq(1, 2, 1/3), rankingType = c(0,1), populationSize = c(20,40,100),offspring = c(0.25,0.5,1),crossOverVal = seq(0,0.5,0.25),mutationChoice = c(0,1,2))
B.SearchSpace = B.SearchSpace[-which(B.SearchSpace$rankingType == 1 & B.SearchSpace$LinearRankingValue != 1),]
B.SearchSpace = mutate(B.SearchSpace,offspring = populationSize*offspring)
# Add a variable that shows progress in percentage (also used later to identify unique parameter combinations)
B.SearchSpace = mutate(B.SearchSpace, progress = 100*(1:nrow(B.SearchSpace))/nrow(B.SearchSpace))
write.table(B.SearchSpace,file = "BentCigFirstIter.txt",row.names = FALSE, col.names = FALSE)

# Alter the searchspace dataframe to match the output file (each parameter combination is run 5 times)
B.SolutionSpace = slice(B.SearchSpace,rep(1:n(), each = 5))

#### Katsuura even smaller again due to time constraints
K.SearchSpace = expand.grid(mutation_step = c(0.5,1), LinearRankingValue = c(1,1.5,2), rankingType = c(0,1), populationSize = c(40,100,200),offspring = 1,crossOverVal = c(0.25,0.5),mutationChoice = c(0,1,2))
K.SearchSpace = K.SearchSpace[-which(K.SearchSpace$rankingType == 1 & K.SearchSpace$LinearRankingValue != 1),]
K.SearchSpace = mutate(K.SearchSpace,offspring = populationSize*offspring)
# Add a variable that shows progress in percentage (also used later to identify unique parameter combinations)
K.SearchSpace = mutate(K.SearchSpace, progress = 100*(1:nrow(K.SearchSpace))/nrow(K.SearchSpace))
write.table(K.SearchSpace,file = "KatsuuraFirstIter.txt",row.names = FALSE, col.names = FALSE)

# Alter the searchspace dataframe to match the output file (each parameter combination is run 5 times)
K.SolutionSpace = slice(K.SearchSpace,rep(1:n(), each = 3))

##########################################
#     First Iteration result analysis    #
#Second Iteration Search Space generation#
##########################################

## Schaffers

S.numSeeds = 5
S.output = read.delim("SchaffersFirstOutput.txt", sep = " ", header = FALSE)
S.output = S.output[which(S.output$V1 == "Score:"),]
S.SolutionSpace = mutate(SolutionSpace, result = as.numeric.factor(S.output$V2))

# find best solution and determine which solutions are not significantly worse than the best solution
tempSummary = summarise(group_by(S.SolutionSpace,progress),result = mean(result))
S.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

S.BestSolutionResults = S.SolutionSpace[S.SolutionSpace$progress == S.BestSolutionIdentifier,]$result
kruskal.test(S.SolutionSpace$result,S.SolutionSpace$progress)
S.analysis = summarise(group_by(S.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,S.BestSolutionResults),rep(1:2,each = S.numSeeds))$P,result = mean(result))

# create new search space containing best solution and solutions that are not significantly worse than best solution
S.2.SearchSpace = select(filter(S.analysis,P>0.05),-progress,-P,-result)
S.2.SearchSpace = mutate(S.2.SearchSpace, progress = 100*(1:nrow(S.2.SearchSpace))/nrow(S.2.SearchSpace))
write.table(S.2.SearchSpace,file = "SchaffersSecondIter.txt",row.names = FALSE, col.names = FALSE)


## Bent Cigar

B.numSeeds = 5
B.output = read.delim("BentCigarFirstOutput.txt", sep = " ", header = FALSE)
#B.output$V1 = as.character(B.output$V1)

#B.output = mutate(B.output,duplicate = ifelse(V1 == lag(V1),1,0))
#missingValue = round(as.numeric.factor(B.output[which(B.output$duplicate==1),]$V2)*nrow(B.SearchSpace)/100,0)
#B.output = B.output[-which(B.output$duplicate==1),]

B.output = B.output[which(B.output$V1 == "Score:"),]
#colnames(B.output) <- c("a","result","b","c")
B.SolutionSpace = mutate(B.SolutionSpace, result = as.numeric.factor(B.output$V2))
#
B.SolutionSpace = left_join(B.SolutionSpace,B.SearchSpace,by = "progress")

# find best solution and determine which solutions are not significantly worse than the best solution
tempSummary = summarise(group_by(B.SolutionSpace,progress),result = mean(result))
B.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

B.BestSolutionResults = B.SolutionSpace[B.SolutionSpace$progress == B.BestSolutionIdentifier,]$result
kruskal.test(B.SolutionSpace$result,B.SolutionSpace$progress)
B.SolutionSpace$progress <- as.factor(B.SolutionSpace$progress)
B.analysis = summarise(group_by(B.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,B.BestSolutionResults),rep(1:2,each = B.numSeeds))$P,result = mean(result))

# create new search space containing best solution and solutions that are not significantly worse than best solution
B.2.SearchSpace = select(filter(B.analysis,P>0.05),-progress,-P,-result)
B.2.SearchSpace = mutate(B.2.SearchSpace, progress = 100*(1:nrow(B.2.SearchSpace))/nrow(B.2.SearchSpace))
write.table(B.2.SearchSpace,file = "BentCigSecondIter.txt",row.names = FALSE, col.names = FALSE)



## Katsuura

K.numSeeds = 3
K.output = read.delim("KatsuuraFirstOutput.txt", sep = " ", header = FALSE)
K.output = K.output[which(K.output$V1 == "Score:"),]
K.SolutionSpace = mutate(K.SolutionSpace, result = as.numeric.factor(K.output$V2))

# find best solution and determine which solutions are not significantly worse than the best solution
tempSummary = summarise(group_by(K.SolutionSpace,progress),result = mean(result))
K.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

K.BestSolutionResults = K.SolutionSpace[K.SolutionSpace$progress == K.BestSolutionIdentifier,]$result
kruskal.test(K.SolutionSpace$result,K.SolutionSpace$progress)
K.analysis = summarise(group_by(K.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,K.BestSolutionResults),rep(1:2,each = K.numSeeds))$P,result = mean(result))

# create new search space containing best solution and solutions that are not significantly worse than best solution
K.2.SearchSpace = select(filter(K.analysis,P>0.05),-progress,-P,-result)
K.2.SearchSpace = mutate(K.2.SearchSpace, progress = 100*(1:nrow(K.2.SearchSpace))/nrow(K.2.SearchSpace))
write.table(K.2.SearchSpace,file = "KatsuuraSecondIter.txt",row.names = FALSE, col.names = FALSE)




#########################################
#    Second Iteration result analysis   #
#Third Iteration Search Space generation#
#########################################


## Schaffers


# Store all results in a second solution space
S.2.numSeeds = 45
S.2.SolutionSpaceNew = slice(S.2.SearchSpace,rep(1:n(), each = S.2.numSeeds))
S.2.SolutionSpaceOld = S.SolutionSpace[S.SolutionSpace$progress %in% filter(S.analysis,P>0.05)$progress,]
S.2.SolutionSpaceOld = mutate(S.2.SolutionSpaceOld,progress = rep(S.2.SearchSpace$progress,each = S.numSeeds))

S.2.Output = read.delim("SchaffersSecondOutput.txt", sep = " ", header = FALSE)
S.2.Output = S.2.Output[which(S.2.Output$V1 == "Score:"),]

S.2.SolutionSpaceNew = mutate(S.2.SolutionSpaceNew, result = as.numeric.factor(S.2.Output$V2))
S.2.SolutionSpace = bind_rows(S.2.SolutionSpaceNew,S.2.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(S.2.SolutionSpace,progress),result = mean(result))
S.2.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

S.2.BestSolutionResults = S.2.SolutionSpace[S.2.SolutionSpace$progress == S.2.BestSolutionIdentifier,]$result
kruskal.test(S.2.SolutionSpace$result,S.2.SolutionSpace$progress)
S.2.analysis = summarise(group_by(S.2.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,S.2.BestSolutionResults),rep(1:2,each = (S.numSeeds+S.2.numSeeds)))$P,result = mean(result))

S.3.SearchSpace = select(filter(S.2.analysis,P>0.05),-progress,-P,-result)
S.3.SearchSpace = mutate(S.3.SearchSpace, progress = 100*(1:nrow(S.3.SearchSpace))/nrow(S.3.SearchSpace))

write.table(S.3.SearchSpace,file = "SchafferThirdIter.txt",row.names = FALSE, col.names = FALSE)


## bent cigar

B.2.numSeeds = 45
B.2.SolutionSpaceNew = slice(B.2.SearchSpace,rep(1:n(), each = B.2.numSeeds))
B.2.SolutionSpaceOld = B.SolutionSpace[B.SolutionSpace$progress %in% filter(B.analysis,P>0.05)$progress,]
B.2.SolutionSpaceOld = mutate(B.2.SolutionSpaceOld,progress = rep(B.2.SearchSpace$progress,each = B.numSeeds))

B.2.Output = read.delim("BentCigarSecondOutput.txt", sep = " ", header = FALSE)
B.2.Output = B.2.Output[which(B.2.Output$V1 == "Score:"),]

B.2.SolutionSpaceNew = mutate(B.2.SolutionSpaceNew, result = as.numeric.factor(B.2.Output$V2))
B.2.SolutionSpace = bind_rows(B.2.SolutionSpaceNew,B.2.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(B.2.SolutionSpace,progress),result = mean(result))
B.2.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

B.2.BestSolutionResults = B.2.SolutionSpace[B.2.SolutionSpace$progress == B.2.BestSolutionIdentifier,]$result
kruskal.test(B.2.SolutionSpace$result,B.2.SolutionSpace$progress)
B.2.analysis = summarise(group_by(B.2.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,B.2.BestSolutionResults),rep(1:2,each = (S.numSeeds+B.2.numSeeds)))$P,result = mean(result))

B.3.SearchSpace = select(filter(B.2.analysis,P>0.05),-progress,-P,-result)
B.3.SearchSpace = mutate(B.3.SearchSpace, progress = 100*(1:nrow(B.3.SearchSpace))/nrow(B.3.SearchSpace))

write.table(B.3.SearchSpace,file = "BentCigarThirdIter.txt",row.names = FALSE, col.names = FALSE)


## Katsuura

K.2.numSeeds = 7
K.2.SolutionSpaceNew = slice(K.2.SearchSpace,rep(1:n(), each = K.2.numSeeds))
K.2.SolutionSpaceOld = K.SolutionSpace[K.SolutionSpace$progress %in% filter(K.analysis,P>0.05)$progress,]
K.2.SolutionSpaceOld = mutate(K.2.SolutionSpaceOld,progress = rep(K.2.SearchSpace$progress,each = K.numSeeds))

K.2.Output = read.delim("KatsuuraSecondOutputWatIsDit.txt", sep = " ", header = FALSE)
K.2.Output = K.2.Output[which(K.2.Output$V1 == "Score:"),]

K.2.SolutionSpaceNew = mutate(K.2.SolutionSpaceNew, result = as.numeric.factor(K.2.Output$V2))
K.2.SolutionSpace = bind_rows(K.2.SolutionSpaceNew,K.2.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(K.2.SolutionSpace,progress),result = mean(result))
K.2.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

K.2.BestSolutionResults = K.2.SolutionSpace[K.2.SolutionSpace$progress == K.2.BestSolutionIdentifier,]$result
kruskal.test(K.2.SolutionSpace$result,K.2.SolutionSpace$progress)
K.2.analysis = summarise(group_by(K.2.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,K.2.BestSolutionResults),rep(1:2,each = (10)))$P,result = mean(result))

K.3.SearchSpace = select(filter(K.2.analysis,P>0.05),-progress,-P,-result)
K.3.SearchSpace = mutate(K.3.SearchSpace, progress = 100*(1:nrow(K.3.SearchSpace))/nrow(K.3.SearchSpace))

write.table(K.3.SearchSpace,file = "KatsuuraThirdIter.txt",row.names = FALSE, col.names = FALSE)

#################################
#Third Iteration result analysis#
#################################

## Bent cigar
B.3.numSeeds = 50
B.3.SolutionSpaceNew = slice(B.3.SearchSpace,rep(1:n(), each = B.3.numSeeds))
B.3.SolutionSpaceOld = B.2.SolutionSpace[B.2.SolutionSpace$progress %in% filter(B.2.analysis,P>0.05)$progress,]
B.3.SolutionSpaceOld = arrange(B.3.SolutionSpaceOld,progress)
B.3.SolutionSpaceOld = mutate(B.3.SolutionSpaceOld,progress = rep(B.3.SearchSpace$progress,each = (B.2.numSeeds+B.numSeeds)))

B.3.Output = read.delim("BentCigarThirdOutput.txt", sep = " ", header = FALSE)
B.3.Output = B.3.Output[which(B.3.Output$V1 == "Score:"),]

B.3.SolutionSpaceNew = mutate(B.3.SolutionSpaceNew, result = as.numeric.factor(B.3.Output$V2))
B.3.SolutionSpace = bind_rows(B.3.SolutionSpaceNew,B.3.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(B.3.SolutionSpace,progress),result = mean(result))
B.3.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

B.3.BestSolutionResults = B.3.SolutionSpace[B.3.SolutionSpace$progress == B.3.BestSolutionIdentifier,]$result
kruskal.test(B.3.SolutionSpace$result,B.3.SolutionSpace$progress)
B.3.analysis = summarise(group_by(B.3.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,B.3.BestSolutionResults),rep(1:2,each = (100)))$P,result = mean(result))

save(B.3.analysis, file="BentCigarBestSolutions.Rdata")

scatter3D(B.3.analysis$mutation_step, B.3.analysis$LinearRankingValue, B.3.analysis$populationSize, colvar = B.3.analysis$crossOverVal)

## Schaffers
S.3.numSeeds = 50
S.3.SolutionSpaceNew = slice(S.3.SearchSpace,rep(1:n(), each = S.3.numSeeds))
S.3.SolutionSpaceOld = S.2.SolutionSpace[S.2.SolutionSpace$progress %in% filter(S.2.analysis,P>0.05)$progress,]
S.3.SolutionSpaceOld = arrange(S.3.SolutionSpaceOld,progress)
S.3.SolutionSpaceOld = mutate(S.3.SolutionSpaceOld,progress = rep(S.3.SearchSpace$progress,each = (S.2.numSeeds+S.numSeeds)))

S.3.Output = read.delim("SchaffersThirdOutput.txt", sep = " ", header = FALSE)
S.3.Output = S.3.Output[which(S.3.Output$V1 == "Score:"),]

S.3.SolutionSpaceNew = mutate(S.3.SolutionSpaceNew, result = as.numeric.factor(S.3.Output$V2))
S.3.SolutionSpace = bind_rows(S.3.SolutionSpaceNew,S.3.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(S.3.SolutionSpace,progress),result = mean(result))
S.3.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

S.3.BestSolutionResults = S.3.SolutionSpace[S.3.SolutionSpace$progress == S.3.BestSolutionIdentifier,]$result
kruskal.test(S.3.SolutionSpace$result,S.3.SolutionSpace$progress)
S.3.analysis = summarise(group_by(S.3.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,S.3.BestSolutionResults),rep(1:2,each = (100)))$P,result = mean(result))

save(S.3.analysis, file="SchaffersBestSolutions.Rdata")

## Katsuura
K.3.numSeeds = 10
K.3.SolutionSpaceNew = slice(K.3.SearchSpace,rep(1:n(), each = K.3.numSeeds))
K.3.SolutionSpaceOld = K.2.SolutionSpace[K.2.SolutionSpace$progress %in% filter(K.2.analysis,P>0.05)$progress,]
K.3.SolutionSpaceOld = arrange(K.3.SolutionSpaceOld,progress)
K.3.SolutionSpaceOld = mutate(K.3.SolutionSpaceOld,progress = rep(K.3.SearchSpace$progress,each = (K.2.numSeeds+K.numSeeds)))

K.3.Output = read.delim("KatsuuraThirdOutput.txt", sep = " ", header = FALSE)
K.3.Output = K.3.Output[which(K.3.Output$V1 == "Score:"),]

K.3.SolutionSpaceNew = mutate(K.3.SolutionSpaceNew, result = as.numeric.factor(K.3.Output$V2))
K.3.SolutionSpace = bind_rows(K.3.SolutionSpaceNew,K.3.SolutionSpaceOld)

# analyse results to find best solution
tempSummary = summarise(group_by(K.3.SolutionSpace,progress),result = mean(result))
K.3.BestSolutionIdentifier = as.numeric(tempSummary[which(tempSummary$result == max(tempSummary$result)),1])
rm(tempSummary)

K.3.BestSolutionResults = K.3.SolutionSpace[K.3.SolutionSpace$progress == K.3.BestSolutionIdentifier,]$result
kruskal.test(K.3.SolutionSpace$result,K.3.SolutionSpace$progress)
K.3.analysis = summarise(group_by(K.3.SolutionSpace,progress),mutation_step = mutation_step[1],LinearRankingValue = LinearRankingValue[1],rankingType = rankingType[1],populationSize = populationSize[1],offspring = offspring[1],crossOverVal = crossOverVal[1], mutationChoice = mutationChoice[1],P = dunn.test(c(result,K.3.BestSolutionResults),rep(1:2,each = (100)))$P,result = mean(result))

save(K.3.analysis, file="KatsuuraBestSolutions.Rdata")

