# 1. Merge the training and the test sets to create one data set.
train.x <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/test/subject_test.txt")
trainData <- cbind(train.subject, train.y, train.x)
testData <- cbind(test.subject, test.y, test.x)
fullData <- rbind(trainData, testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
featureName <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])

# 3. Uses descriptive activity names to name the activities in the data set
activityName <- read.table("/Users/lydc/datascience/specdata/UCI HAR Dataset/activity_labels.txt")
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])

# 4. Appropriately labels the data set with descriptive variable names.
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
groupData <- finalData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(groupData, "/Users/lydc/datascience/specdata/UCI HAR Dataset//MeanData.txt", row.names = FALSE)
