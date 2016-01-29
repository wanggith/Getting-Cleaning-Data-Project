library(reshape2)
library(dplyr)

setwd("C:\\GettingCleaningDataProject")

#Download and unzip files
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./dataset.zip")
unzip("dataset.zip")

setwd("UCI HAR Dataset/")

#Extract only the measurements on the mean and standard deviation.
featureData <- read.table("features.txt", col.names=c("id", "name"))
featuresID <- grep("(mean|std)", featureData$name)
featureName <- featureData[featuresID, 2]

#Use descriptive activity names
featureName <- gsub("-mean", "Mean", featureName)
featureName <- gsub("-std", "Std", featureName)
featureName <- gsub("[()-]", "", featureName)

#Read data set into R
trainData <- read.table("./train/X_train.txt")[,featuresID]
trainSubjects <- read.table("./train/subject_train.txt")
trainActivities <- read.table("./train/y_train.txt")
trainData <- cbind(trainSubjects, trainActivities, trainData)
testData <- read.table("./test/X_test.txt")[,featuresID]
testSubjects <- read.table("./test/subject_test.txt")
testActivities <- read.table("./test/y_test.txt")
testData <- cbind(testSubjects, testActivities, testData)

#Merge the training and the test sets, and label the data set with descriptive variable names
finalData <- rbind(trainData, testData)
colnames(finalData) <- c("subject", "activity", featureName)
MeltFinalData <- melt(finalData, id=c("subject", "activity"))
colnames(MeltFinalData)[3] <- "description"

#Group data set, and calculate the average of each variable for each activity and each subject.
groupData <- group_by(MeltFinalData, subject, activity, description)
MeanData <- summarize(groupData, value=mean(value))

#Create tidy data set
write.table(MeanData, "tidydata.txt", row.names=FALSE, quote=FALSE)