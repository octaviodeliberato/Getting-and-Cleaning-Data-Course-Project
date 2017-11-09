library(rio)
library(tidyr)
library(dplyr)

setwd("C:/Users/Octavio/Getting and Cleaning Data Course Project/course project")

zipfile <- "samsung.zip"

# Download and unzip
if (!file.exists(zipfile)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, zipfile)
}
if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipfile) 
}

# Load activity labels and vars
activityLabels <- import("UCI HAR Dataset/activity_labels.txt")
variables <- import("UCI HAR Dataset/features.txt")

# Extract mean and std data
desiredVars <- grep("mean|std", variables[,2])
desiredVars.names <- variables[desiredVars,2]
desiredVars.names = gsub('-mean', 'Mean', desiredVars.names)
desiredVars.names = gsub('-std', 'Std', desiredVars.names)
desiredVars.names <- gsub('[()-]', '', desiredVars.names)


# Load the datasets
train <- import("UCI HAR Dataset/train/X_train.txt")[desiredVars]
trainActivities <- import("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- import("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- import("UCI HAR Dataset/test/X_test.txt")[desiredVars]
testActivities <- import("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- import("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Bind them, add labels
wholeDS <- rbind(train, test)
colnames(wholeDS) <- c("subject", "activity", desiredVars.names)

# Turn activities & subjects into factors
wholeDS$activity <- factor(wholeDS$activity, levels = activityLabels[,1], labels = activityLabels[,2])
wholeDS$subject <- as.factor(wholeDS$subject)

# Generate the tidy dataset -> tidy.txt
wholeDS.gather <- gather(wholeDS,key=variable,value=value,-subject,-activity)
wholeDS.group <- group_by(wholeDS.gather,subject,activity,variable)
wholeDS.mean <- summarise(wholeDS.group,average=mean(value))
wholeDS.final<-spread(wholeDS.mean,key = variable,value = average)
export(wholeDS.final, "tidy.txt")