# TidyDataProject
run_analysis.R is a script file for transforming data from the Human Activity Recognition Using Smartphones study. A full description is available at the site where the data was obtained: 

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

The data is located here:
	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

The script file assumes the above data was unzipped into your RStudio working directory.  

The script has two outputs: 1. a dataframe named fulldata. 2. a file in your working directory named fulldatamean.txt

The scrip does the following transformations:
	1. Merges the training and the test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement. 
	3. Uses descriptive activity names to name the activities in the data set
	4. Appropriately labels the data set with descriptive variable names. 
	5. From the data set in step 4, creates a second, independent tidy data set with the 
	   average of each variable for each activity and each subject.

A code book, Data_info.txt, describing the data is located in this same directory.