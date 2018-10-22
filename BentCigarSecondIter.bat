@ECHO OFF
cd C:\Users\Jan Haenen\Desktop\assignmentfiles_2018 (1)\assignmentfiles_2017
FOR /F "tokens=1,2,3,4,5,6,7,8" %%A IN (BentCigSecondIter.txt) DO (
	powershell -Command "(gc UtilityEmty.java) -replace 'mutation_step =', ('mutation_step = ' + [string]%%A) -replace 'linearRankingValue =', ('linearRankingValue = ' + [string]%%B) -replace 'rankingType =', ('rankingType = ' + [string]%%C) -replace 'populationSize =', ('populationSize = ' + [string]%%D) -replace 'offspringNumber =', ('offspringNumber = ' + [string]%%E) -replace 'arithmeticCrossoverVal =', ('arithmeticCrossoverVal = ' + [string]%%F) -replace 'mutationChoice =', ('mutationChoice = ' + [string]%%G) | Out-File Utility.java -encoding "OEM"
	javac -classpath contest.jar player22.java Individual.java Population.java Utility.java
	jar uf contest.jar Population.class Individual.class Utility.class
	FOR /L %%I IN (6,1,50) DO (
		ping 192.0.2.1 -n 1 -w 0 >nul
		@echo progress %%H >> BentCigarSecondOutput.txt
		java -jar testrun.jar -submission=player22 -evaluation=BentCigarFunction -seed=%%I >> BentCigarSecondOutput.txt
	)
	ECHO %%H
) 