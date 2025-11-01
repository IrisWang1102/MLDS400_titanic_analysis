library(caret)
library(readr) 

#BASE_DIR <- dirname(dirname(normalizePath(sys.frame(1)$ofile, mustWork = FALSE)))

#TRAIN_PATH <- file.path(BASE_DIR, "data", "train.csv")
#TEST_PATH  <- file.path(BASE_DIR, "data", "test.csv")
#OUTPUT_PATH <- file.path(BASE_DIR, "predictionsR.csv")

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- dirname(sub(file_arg, "", args[grep(file_arg, args)]))

if (length(script_path) == 0) {
  # when using source() or interactive mode
  script_path <- file.path(getwd(), "src", "appR")
}

BASE_DIR <- normalizePath(file.path(script_path, ".."))
cat("Resolved BASE_DIR:", BASE_DIR, "\n")

TRAIN_PATH <- file.path(BASE_DIR, "data", "train.csv")
TEST_PATH  <- file.path(BASE_DIR, "data", "test.csv")
OUTPUT_PATH <- file.path(BASE_DIR, "predictionsR.csv")

train_df <- readr::read_csv(TRAIN_PATH, show_col_types = FALSE)
test_df  <- readr::read_csv(TEST_PATH,  show_col_types = FALSE)

cat("train_df shape:", dim(train_df), "\n")
cat("test_df shape:", dim(test_df), "\n")

drop_cols <- c("Cabin", "Ticket")
train_df <- train_df[, !(names(train_df) %in% drop_cols), drop = FALSE]
test_df  <- test_df[,  !(names(test_df)  %in% drop_cols), drop = FALSE]
cat("Drop columns 'Cabin' and 'Ticket'\n")

train_df$Age[is.na(train_df$Age)] <- median(train_df$Age, na.rm = TRUE)
train_df$Embarked[is.na(train_df$Embarked)] <-
  names(sort(table(train_df$Embarked), decreasing = TRUE))[1]

test_df$Age[is.na(test_df$Age)] <- median(test_df$Age, na.rm = TRUE)
test_df$Fare[is.na(test_df$Fare)] <- median(test_df$Fare, na.rm = TRUE)
test_df$Embarked[is.na(test_df$Embarked)] <-
  names(sort(table(test_df$Embarked), decreasing = TRUE))[1]

cat("Fill in NA for column 'Age', 'Fare', 'Embarked' using median and mode\n")

train_df$Sex     <- as.numeric(factor(train_df$Sex))
train_df$Embarked <- as.numeric(factor(train_df$Embarked))

sex_levels      <- levels(factor(train_df$Sex))
embarked_levels <- levels(factor(train_df$Embarked))

test_df$Sex     <- as.numeric(factor(test_df$Sex,     levels = sex_levels))
test_df$Embarked <- as.numeric(factor(test_df$Embarked, levels = embarked_levels))

cat("Encode categorical variables for 'Sex' and 'Embarked'\n")

features <- c("Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked")
X_train <- train_df[, features]
y_train <- train_df$Survived
X_test  <- test_df[, features]

cat("Set features, X_train, X_test, y_train\n")

model <- glm(Survived ~ ., data = data.frame(Survived = y_train, X_train),
             family = binomial())
cat("Model trained successfully using glm() with binomial family\n")

predictions_prob <- predict(model, newdata = X_test, type = "response")
predictions <- ifelse(predictions_prob > 0.5, 1, 0)

y_train_pred <- ifelse(predict(model, type = "response") > 0.5, 1, 0)
train_accuracy <- mean(y_train_pred == y_train)
cat(sprintf("train_accuracy: %.4f\n", train_accuracy))

output_df <- data.frame(
  PassengerId = test_df$PassengerId,
  Survived    = predictions
)

readr::write_csv(output_df, OUTPUT_PATH)
cat("Predictions saved to", OUTPUT_PATH, "\n")




