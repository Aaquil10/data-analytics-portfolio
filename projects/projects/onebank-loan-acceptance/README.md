# Predicting Loan Acceptance for OneBank (Ensemble Models)

## Overview
This project was completed for **DA/CSC 423/523 (Business Data Analytics)** under **Professor Aysegul Cuhadar**. OneBank launched a campaign to encourage existing customers to accept a consumer loan offer. Using historical campaign data (**bank.csv**), the goal is to build a predictive model that identifies customers most likely to accept the offer, enabling the bank to reduce marketing costs by targeting a smaller, higher-probability group.

The outcome variable is **loan** (accepted vs. not accepted).

---

## Business Problem
Marketing campaigns can be expensive when offered broadly. This project focuses on improving targeting efficiency by predicting loan acceptance so that outreach can be directed toward customers with the highest likelihood of responding positively.

---

## Data
- Dataset: `bank.csv` (from a previous promotional campaign)
- Target variable: `loan`

> The raw dataset is not included in this repository.

---

## Methods & Workflow
1. **Data Preprocessing**
   - Cleaned and prepared the dataset for modeling
   - Encoded categorical variables as needed
   - Verified target variable format

2. **Train/Validation Split**
   - Partitioned into training and validation sets using an **80/20 split**

3. **Baseline Models**
   Three classification models were trained and evaluated:
   - **Naïve Bayes** (required)
   - **Logistic Regression**
   - **Decision Tree**

4. **Evaluation**
   - Generated **confusion matrices** for each model
   - Calculated **accuracy** and compared error rates across models

5. **Ensemble Methods**
   A combined results table was created containing:
   - Actual outcome
   - Predictions from each model
   - Predicted probabilities

   Two ensemble strategies were then applied:

   **A) Majority Vote**
   - Predicts 1 if at least **two out of three** models predict 1

   **B) Average Probability**
   - Predicts 1 if the **average predicted probability** across models is **≥ 0.5**

   Each ensemble method was evaluated using:
   - Confusion matrix
   - Overall accuracy
   - Error rate comparison versus individual models

---

## Key Deliverables
- Fully documented Jupyter Notebook with step-by-step markdown explanations
- Model comparison table (individual models vs ensemble methods)
- Final evaluation summary using confusion matrices and accuracy

---

## Tools & Libraries
- **Python (Jupyter Notebook)**
  - pandas, numpy
  - scikit-learn
- Evaluation:
  - confusion matrix
  - accuracy score

---

## Repository Contents
