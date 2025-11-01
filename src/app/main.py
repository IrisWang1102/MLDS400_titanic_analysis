import pandas as pd
import matplotlib.pyplot as plt

import os
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# 获取当前文件的绝对路径
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

TRAIN_PATH = os.path.join(BASE_DIR, 'data', 'train.csv')
train_df = pd.read_csv(TRAIN_PATH)

print(f'train_df shape: {train_df.shape}')

TEST_PATH = os.path.join(BASE_DIR, 'data', 'test.csv')
test_df = pd.read_csv(TEST_PATH)

print(f'test_df shape: {test_df.shape}')

output_path = os.path.join(BASE_DIR, 'data', 'predictions.csv')

train_df.drop(columns=['Cabin', 'Ticket'], inplace=True)
test_df.drop(columns=['Cabin', 'Ticket'], inplace=True)
print(f"Drop columns 'Cabin' and 'Ticket'")

train_df = train_df.copy()
test_df = test_df.copy()
train_df['Age'] = train_df['Age'].fillna(train_df['Age'].median())
train_df['Embarked'] = train_df['Embarked'].fillna(train_df['Embarked'].mode()[0])
test_df['Age'] = test_df['Age'].fillna(test_df['Age'].median())
test_df['Fare'] = test_df['Fare'].fillna(test_df['Fare'].median())
test_df['Embarked'] = test_df['Embarked'].fillna(test_df['Embarked'].mode()[0])
print("Fill in na for column 'Age', 'Fare', 'Embarked' using median and mode")

le_sex = LabelEncoder()
le_embarked = LabelEncoder()
train_df['Sex'] = le_sex.fit_transform(train_df['Sex'])
test_df['Sex'] = le_sex.transform(test_df['Sex'])
train_df['Embarked'] = le_embarked.fit_transform(train_df['Embarked'])
test_df['Embarked'] = le_embarked.transform(test_df['Embarked'])
print("Encode categorical variables for column 'Sex' and 'Embarked' with LabelEncoder()")

features = ['Pclass', 'Sex', 'Age', 'SibSp', 'Parch', 'Fare', 'Embarked']
X_train = train_df[features]
y_train = train_df['Survived']
X_test = test_df[features]
print("Set features, X_train, X_test, y_train")

model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print("Model trained successfully using LogisticRegression()")

predictions = model.predict(X_test)

y_train_pred = model.predict(X_train)
train_accuracy = accuracy_score(y_train, y_train_pred)
print(f'train_accuracy: {train_accuracy:.4f}')

output_df = pd.DataFrame({
    'PassengerId': test_df['PassengerId'],
    'Survived': predictions
})
output_df.to_csv(output_path, index=False)
print(f"Predictions saved to {output_path}")





