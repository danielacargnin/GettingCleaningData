#Downloading and extracting files

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="libcurl")
unzip(zipfile="./Dataset.zip",exdir="./")

# 1.Merges the training and the test sets to create one data set.

  # 1.1 Reading variables names
varNames<-read.table("./UCI HAR Dataset/features.txt")

  # 1.2 Reading TEST tables 
testFile<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names=varNames[,2])
testLabels<-read.table("./UCI HAR Dataset/test/y_test.txt",col.names=c("Labels"))
testId<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names=c("ID"))

  # 1.3 Reading TRAIN tables 
trainFile<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names=varNames[,2])
trainLabels<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names=c("Labels"))
trainId<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names=c("ID"))

 # 1.4 Merge all files (test and train)
data<-rbind(trainFile,testFile)
labels<-rbind(trainLabels,testLabels)
id<-rbind(trainId,testId)

mergedData<-cbind(id,labels,data)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement

measurementsMeanStd <- varNames[grep("mean\\(\\)|std\\(\\)", varNames$V2), ]
## increment by 2 because data has subjects and labels in the beginning
dataMeanStd <- mergedData[, c(1, 2, measurementsMeanStd$V1+2)]

#3. Uses descriptive activity names to name the activities in the data set
activitiesLabel<-read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c('Labels','activityType'))
mergedData = merge(mergedData,activitiesLabel,by='Labels',all.x=TRUE);

#4. Appropriately labels the data set with descriptive variable names. 
library(dplyr)
mergedData<-rename(mergedData,Activity=Labels,Subject=ID)

#5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

finalTidyData= ddply(mergedData, c("Subject","Activity"), numcolwise(mean))
write.table(finalTidyData, file = "finalTidyData.txt",  row.name=FALSE)