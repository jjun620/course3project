

library(dplyr)

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
sub_train <- read.table("./train/subject_train.txt")


x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
sub_test <- read.table("./test/subject_test.txt")


feature <- read.table("./features.txt")

activity_label <- read.table("./activity_labels.txt")


#1. Merging the training and test sets
x_bind <- rbind(x_train, x_test)
y_bind <- rbind(y_train, y_test)
sub_bind <- rbind(sub_train, sub_test)

View(sub_bind)

#2.Extracts only the measurements on the mean and standard deviation for each measurement
MeanStd_select <- feature[grep("mean\\(\\)|std\\(\\)",feature[,2]),]
x_bind <- x_bind[,MeanStd_select[,1]] 

MeanStd_select

#U3.Uses descriptive activity names to name the activities in the data set
colnames(y_bind) <- "activities"

View(y_bind)
y_bind$Descrip_actname <- activity_label[y_bind[ ,1], 2]

colnames(y_bind)
y_bind$Descrip_actname

# 4. Appropriately labels the data set with descriptive variable names.
colnames(x_bind) <- feature[MeanStd_select[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(sub_bind) <- "subject"
data_second <- cbind(x_bind, y_bind$Descrip_actname, sub_bind)
Summary = summarise_all(group_by(data_second, y_bind$Descrip_actname, subject), funs(mean))
write.table(data_second, "./summary.txt", row.names = FALSE)


summary <- read.table("./summary.txt", head= T)

View(summary)
