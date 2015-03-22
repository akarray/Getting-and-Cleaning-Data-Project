# Merges the training and the test sets to create one data set.

require(plyr)


setwd("~/work/data_science/cleaning_data/project/Getting-and-Cleaning-Data-Project/data")

# load usefull data

x_training = read.table("UCI HAR Dataset/train/X_train.txt")
y_training = read.table("UCI HAR Dataset/train/y_train.txt")
subject_training = read.table("UCI HAR Dataset/train/subject_train.txt")
x_testing = read.table("UCI HAR Dataset/test/X_test.txt")
y_testing = read.table("UCI HAR Dataset/test/y_test.txt")
subject_testing = read.table("UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityId", "Activity"))
features <- read.table("./UCI HAR Dataset/features.txt")

# merge data training and testing data
training_sensor_data <- cbind(cbind(x_training, subject_training), y_training)
testing_sensor_data <- cbind(cbind(x_testing, subject_testing), y_testing)
sensor_data <- rbind(training_sensor_data, testing_sensor_data)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Label columns & Appropriately labels the data set with descriptive variable names. 
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]

names(sensor_data) <- sensor_labels

extract_features <- grepl("Mean|Std|Subject|ActivityId", names(sensor_data))

sensor_data_clean <- sensor_data[, extract_features]


# Uses descriptive activity names to name the activities in the data set

sensor_data_clean <- join(sensor_data_clean, activity_labels, by = "ActivityId", match = "first")
sensor_data_clean <- sensor_data_clean[,-1]


# creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- ddply(sensor_data_clean, c("Subject","Activity"), numcolwise(mean))
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)
