#1. Unzipping the file
fileur <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileur,destfile="D:/g3/dataset.zip")

unzip(zipfile="D:/g3/dataset.zip",exdir="D:/g3/dataset")


# 1: Merging training and test data sets

# 1.1Reading training data sets
x_train <- read.table("D:/g3/dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("D:/g3/dataset/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("D:/g3/dataset/UCI HAR Dataset/train/subject_train.txt")

# 1.2 Reading test data sets
x_test <-  read.table("D:/g3/dataset/UCI HAR Dataset/test/X_test.txt")
y_test <-  read.table("D:/g3/dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("D:/g3/dataset/UCI HAR Dataset/test/subject_test.txt")

#2 Reading feature and activity labels
activity_labels<-  read.table("D:/g3/dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("D:/g3/dataset/UCI HAR Dataset/features.txt")

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c("activityId","activityType")
# 1.4 Merging data sets
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_train, merge_test)

# 3. Extracting only measurements related to mean and standard deviation

colNames <- colnames(setAllInOne)
mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
  )
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#4. Use descriptive activity names
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
secondTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secondTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secondTidySet.txt", row.name=FALSE)
