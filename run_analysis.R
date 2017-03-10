# This R script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Read in necessary packages

library(plyr)
library(dplyr)
library(reshape2)

# Read in training data, assign column names, and merge

subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(subTrain) <- "subject"
actTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
colnames(actTrain) <- "activity"
actTrain[actTrain == 1] <- "walking"
actTrain[actTrain == 2] <- "walking_upstairs"
actTrain[actTrain == 3] <- "walking_downstairs"
actTrain[actTrain == 4] <- "sitting"
actTrain[actTrain == 5] <- "standing"
actTrain[actTrain == 6] <- "laying"
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
trainDataColnames <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
colnames(trainData) <- (trainDataColnames[,2])
train <- cbind(subTrain, actTrain, trainData)

# Read in test data, assign column names, and merge

subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
colnames(subTest) <- "subject"
actTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
colnames(actTest) <- "activity"
actTest[actTest == 1] <- "walking"
actTest[actTest == 2] <- "walking_upstairs"
actTest[actTest == 3] <- "walking_downstairs"
actTest[actTest == 4] <- "sitting"
actTest[actTest == 5] <- "standing"
actTest[actTest == 6] <- "laying"
testData <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
testDataColnames <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
colnames(testData) <- (testDataColnames[,2])
test <- cbind(subTest, actTest, testData)

# Combine training and test data, remove duplicate columns and extract only measurements with mean and standard deviation

data <- rbind(train, test)
data <- data[ , !duplicated(colnames(data))]
data_extract <- select(data, subject, activity, contains("mean()"), contains("std()"))

# Assign descriptive activity names to the activity variables

names(data_extract) <- gsub("Acc", "Acceleration", names(data_extract))
names(data_extract) <- gsub("^t", "Time", names(data_extract))
names(data_extract) <- gsub("^f", "Frequency", names(data_extract))
names(data_extract) <- gsub("BodyBody", "Body", names(data_extract))
names(data_extract) <- gsub("mean", "Mean", names(data_extract))
names(data_extract) <- gsub("std", "Std", names(data_extract))
names(data_extract) <- gsub("Freq", "Frequency", names(data_extract))
names(data_extract) <- gsub("Mag", "Magnitude", names(data_extract))

# Create tidy dataset with mean for each column

data_tidy<- ddply(data_extract, c("subject", "activity"), numcolwise(mean))

write.table(data_tidy, file="tidydata.txt")