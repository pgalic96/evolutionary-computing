@ECHO OFF
:: change writing directory to your writing directory
:: file with searchspace is named SchaffersFirstIter.txt here (first for loop) change to the searchspace you are working with
:: Make sure the UtilityEmty.java file is in the folder
:: Make sure the output file (SchaffersFirstOutput.txt here) is empty or does not exist before running the code
:: Make sure you have the updated player22.java file (with changable survivor selection parameters)
cd C:\Users\Jan Haenen\Desktop\assignmentfiles_2018 (1)\assignmentfiles_2017
FOR /F "tokens=1,2,3,4,5,6,7,8" %%A IN (SchaffersFirstIter.txt) DO (
	powershell -Command "(gc UtilityEmty.java) -replace 'mutation_step =', ('mutation_step = ' + [string]%%A) -replace 'linearRankingValue =', ('linearRankingValue = ' + [string]%%B) -replace 'rankingType =', ('rankingType = ' + [string]%%C) -replace 'populationSize =', ('populationSize = ' + [string]%%D) -replace 'offspringNumber =', ('offspringNumber = ' + [string]%%E) -replace 'arithmeticCrossoverVal =', ('arithmeticCrossoverVal = ' + [string]%%F) -replace 'mutationChoice =', ('mutationChoice = ' + [string]%%G) | Out-File Utility.java -encoding "OEM"
	javac -classpath contest.jar player22.java Individual.java Population.java Utility.java
	jar uf contest.jar Population.class Individual.class Utility.class
	FOR %%I IN (1,2,3,4,5) DO (
		java -jar testrun.jar -submission=player22 -evaluation=SchaffersEvaluation -seed=%%I >> SchaffersFirstOutput.txt
	)
	ECHO %%H
) 