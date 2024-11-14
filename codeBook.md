# CodeBook for Tidy Data

## Data Sources
The data was derived from the Human Activity Recognition Using Smartphones Dataset Version 1.0.

## Variables
- `subject`: Identifies each subject in the experiment.
- `activity`: The activity performed by the subject, labeled descriptively.
- `TimeBodyAccelerometer-mean()-X`, `TimeBodyAccelerometer-mean()-Y`, ...: Mean body acceleration along the X, Y, and Z axes (and so on for each feature).

## Transformations
- Merged training and test data.
- Extracted only mean and standard deviation measurements.
- Applied descriptive activity names.
- Appropriately labeled the data with descriptive variable names.
- Created an independent dataset with the average of each variable for each subject and activity.
