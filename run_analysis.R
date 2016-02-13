#       ========================================================================
#       Criteria for grading
#       ------------------------------------------------------------------------
#       The submitted data set is tidy.
#       The Github repo contains the required scripts.
#       GitHub contains a code book that modifies and updates the available 
#               codebooks with the data to indicate all the variables and 
#               summaries calculated, along with units, and any other relevant 
#               information.
#       The README that explains the analysis files is clear and understandable.
#       The work submitted for this project is the work of the 
#               student who submitted it.
#               
#       ========================================================================


#       ========================================================================
#       Steps to take:
#       ------------------------------------------------------------------------
#       1. Merges the training and the test sets to create one data set.
#       2. Extracts only the measurements on the mean and standard deviation 
#               for each measurement.
#       3. Uses descriptive activity names to name the activities in 
#               the data set
#       4. Appropriately labels the data set with descriptive variable names.
#       5. From the data set in step 4, creates a second, independent tidy 
#               data set with the average of each variable for each activity 
#               and each subject.
#       ========================================================================



#       Merge the training and test data set
#       Use cached results, to keep this fast (need to clear the workspace to reload)
if (!exists("allData")) {
        trainingData <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
        testData     <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
}
allData      <- rbind(trainingData,testData)        


#       Assign field names
fieldNames <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
names(allData)<-fieldNames$V2

#       Keep only the mean and std fields
meanOrStdField <- grepl("mean|std",names(allData))
allData        <- allData[,meanOrStdField]

#       Label the activities descriptively
#       First, merge the test and train labels, consistent with data
trainingLabels <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
testLabels     <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
allLabels      <- rbind(trainingLabels,testLabels)

#       Now create the activity labels column
activityLabels <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
activityNames  <- activityLabels[allLabels$V1,"V2"]
allData        <- cbind(activityNames,allData)

#       Now name the subjects. Keep order consistent as above!
trainingSubjects  <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
testingSubjects   <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
allSubjects       <- rbind(trainingSubjects,testingSubjects)
names(allSubjects)[1] <- "Subject"
allData           <- cbind(allSubjects,allData)

#       Now clean up the column names
#       Create a list of items and how they will be replace, 
#       then loop over the list.
substitutions <- list(
        c("\\(\\)",""), c("-","") ,c("^t","Time"), c("^f","Frequency"),
        c("std","Std"), c("mean","Mean"),
        c("BodyBody","Body"), c("activityNames","Activity")
)

for (pair in substitutions){
        names(allData) <- gsub(pattern=pair[1],replacement=pair[2],x=names(allData))
}


#       Now create a second, independent tidy 
#       data set with the average of each variable for each activity 
#       and each subject.
colsToAverage <- grepl("Mean|Std",names(allData))
tidyData <- ddply(allData,.(Subject,Activity),function(x){colMeans(x[,colsToAverage])})

#       Save the data to a file
#       Don't include the row names, they aren't needed.  
#       Each row is uniquely defined by the pair (Subject,Activity)
write.table(tidyData,"tidyData.txt",row.names = FALSE)  
#       Load using read.table("tidyData.txt", header = TRUE)

