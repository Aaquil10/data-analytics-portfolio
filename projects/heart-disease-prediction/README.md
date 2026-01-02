# Heart Disease Prediction Using Machine Learning

## Overview
This project applies machine learning techniques to predict the presence of heart disease based on clinical and demographic features. The goal is to build accurate and interpretable classification models that can help identify individuals at higher risk of heart disease using structured health data.

All analysis is conducted in **Python using Jupyter Notebook**, following a complete end-to-end data science workflow.

---

## Data
The dataset is based on a publicly available **Heart Disease dataset (UCI / Kaggle)** containing patient-level clinical information such as:
- Age
- Sex
- Chest pain type
- Resting blood pressure
- Cholesterol
- Fasting blood sugar
- Resting ECG results
- Maximum heart rate
- Exercise-induced angina
- ST depression and slope

> Raw data files are not included in this repository.  
> The dataset can be obtained from public UCI or Kaggle repositories.

---

## Objectives
- Clean and preprocess clinical health data
- Perform exploratory data analysis (EDA) to understand feature distributions
- Identify key risk factors associated with heart disease
- Train and compare multiple classification models
- Evaluate model performance using appropriate metrics

---

## Tools & Libraries
- **Python**
  - pandas
  - numpy
  - matplotlib
  - seaborn
- **Machine Learning**
  - scikit-learn
- **Environment**
  - Jupyter Notebook

---

## Analysis Workflow
### 1. Data Preparation
- Handled missing values and inconsistent entries
- Encoded categorical variables
- Scaled numerical features where required
- Defined binary target variable (heart disease present vs. not present)

### 2. Exploratory Data Analysis (EDA)
- Examined distributions of clinical variables
- Analyzed relationships between features and heart disease outcome
- Visualized correlations and group-level differences

### 3. Modeling
Multiple classification models were trained and evaluated, including:
- Logistic Regression
- Decision Tree Classifier
- Random Forest Classifier

### 4. Model Evaluation
Models were evaluated using:
- Accuracy
- Precision
- Recall
- F1-score
- ROC-AUC

Performance comparisons were used to identify the best-performing and most interpretable model.

---

## Key Results
- Certain clinical features (e.g., chest pain type, maximum heart rate, exercise-induced angina) showed strong association with heart disease
- Ensemble models (Random Forest) generally outperformed simpler models
- Logistic Regression provided interpretable baseline results suitable for risk analysis

---
