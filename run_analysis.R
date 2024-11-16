# Load necessary libraries
library(dplyr)
library(tidyverse)
# Define URL and download the data if not already downloaded
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("dataset.zip")) {
  download.file(url, destfile = "dataset.zip", method = "curl")
}
unzip("dataset.zip")
# Load feature names and activity labels
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("index", "feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Load training data
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Load test data
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
# Merge the datasets
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
subject_data <- rbind(train_subject, test_subject)

# Step 1: Clean feature names to match merged_data
features$clean_feature <- make.names(features$feature)

# Step 2: Extract mean and std columns
mean_std_columns <- grep("mean\\(\\)|std\\(\\)", features$feature, value = TRUE)
cleaned_mean_std_columns <- make.names(mean_std_columns)

# Step 3: Verify matching columns
matched_columns <- intersect(cleaned_mean_std_columns, colnames(merged_data))

# Step 4: Subset merged_data using matched columns
tidy_data <- merged_data %>% select(subject, code, all_of(matched_columns))

# Combine all data into one dataset
merged_data <- cbind(subject_data, y_data, x_data)
# Extract columns with mean and std measurements
mean_std_columns <- grep("-(mean|std)\\(\\)", features$feature, value = TRUE)
# Select only the mean and std columns along with subject and activity code
tidy_data <- merged_data %>% select(subject, code, all_of(mean_std_columns))
# Replace activity codes with descriptive names
tidy_data$code <- activities[tidy_data$code, 2]
colnames(tidy_data)[2] <- "activity"  # Rename 'code' column to 'activity'
# Update column names with descriptive labels
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
# Create a second independent tidy dataset with averages
final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean))

# Write the final tidy dataset to a file
write.table(final_data, "tidy_data.txt", row.names = FALSE)
