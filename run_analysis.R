
# assumes data was unziped in the current working dirctory

library(dplyr)
library(data.table)

training_Xfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
training_yfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"
test_Xfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"
test_yfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
ffile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"
subject_testfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"
subject_trainfile <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"
dimActivitylabelsfile <-"./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt"

trainingdata <- read.table(training_Xfile, fill = F)
traininglabels<-read.table(training_yfile, fill =F)
testdata <- read.table(test_Xfile, fill = F)
testlabels<-read.table(test_yfile, fill =F)
features <- read.table(ffile, fill=F)
subject_test <- read.table(subject_testfile)
subject_train <- read.table(subject_trainfile)
dimActivitylabels <- read.table(dimActivitylabelsfile) #dimension table with activity id and activity
names(dimActivitylabels)<-c("activityID","activity")

# ==============================================================================
# Add feature names to the data
# ==============================================================================
names(trainingdata)<-features[,2]
names(testdata)<-features[,2]

# ==============================================================================
# select only the features with mean, Mean, or std
# ==============================================================================
trainingdata <- trainingdata[,(grepl("mean", names(trainingdata)) | grepl("Mean", names(trainingdata)) | grepl("std", names(trainingdata)))]
        # returns [7352, 86]
testdata <- testdata[,(grepl("mean", names(testdata)) | grepl("Mean", names(testdata)) | grepl("std", names(testdata)))]
        # returns [2947,86]

# ==============================================================================
# Add activity id data. 
# ==============================================================================
trainingdata <- cbind(traininglabels, trainingdata)
colnames(trainingdata)[1] <- "activityID"
testdata <- cbind(testlabels, testdata)
colnames(testdata)[1] <- "activityID"


# =============================================================================
# # Add participant data
# =============================================================================
trainingdata <- cbind(subject_train, trainingdata)
colnames(trainingdata)[1] <- "subjectID"

testdata <- cbind(subject_test, testdata)
colnames(testdata)[1] <- "subjectID"

# ==============================================================================
# Uses descriptive activity names to name the activities in the data set
# ==============================================================================

trainingdata<-inner_join(dimActivitylabels, trainingdata)
testdata<-inner_join(dimActivitylabels, testdata)


# ==============================================================================
# Merge training and test data sets
#       this is the final data frame with all requirements met in the first 4 steps
# ==============================================================================
fulldata <- rbind(testdata, trainingdata)
# returns [10299, 89]

# ==============================================================================
# Change variable names to descriptive
# ==============================================================================
names(fulldata) <- gsub("tBodyAcc","timeBodyAcceleration", names(fulldata))
names(fulldata) <- gsub("Mag","Magnitude", names(fulldata))
names(fulldata) <- gsub("fBodyAcc","frequencyBodyAcceleration", names(fulldata))
names(fulldata) <- gsub("fBodyGyro","frequencyBodyGyro", names(fulldata))
names(fulldata) <- gsub("tBodyGyro","timeBodyGyro", names(fulldata))
names(fulldata) <- gsub("tGravityAcc","timeGravityAcceleration", names(fulldata))
names(fulldata) <- gsub("fBodyBodyAcc","frequencyBodyBodyAcceleration", names(fulldata))
names(fulldata) <- gsub("fBodyBodyGyro","frequencyBodyBodyGyro", names(fulldata))
#=============================================================================== 
# STEP 5: 
# From the data set in step 4, creates a second, independent 
# tidy data set with the average of each variable for each activity and each subject.
#       input: fulldata (data frame)
#       output: fulldatamean (table), fulldatamean.txt (file)
# ==============================================================================
#convert data frame to data table
fulldataDT <- data.table(fulldata) 
# get the mean of all columns
fulldatamean<-fulldataDT[, lapply(.SD, mean), by = c("subjectID","activity")]

# change variable names to reflect mean operation
names(fulldatamean)<- gsub("angle", "mean_angle", names(fulldatamean))
names(fulldatamean)<- gsub("frequency", "mean_frequency", names(fulldatamean))
names(fulldatamean)<- gsub("time", "mean_time", names(fulldatamean))

# write the table to a file
write.table(fulldatamean, file="./fulldatamean.txt", row.names = F)
