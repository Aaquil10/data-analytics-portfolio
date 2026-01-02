# DC Traffic Crash Analysis (Python, Geospatial Analytics & Machine Learning)

## Overview
This project analyzes large-scale traffic crash data from **Washington, DC** using **Python and Jupyter Notebook**. The primary focus is on understanding crash severity patterns, evaluating the impact of **automated traffic enforcement cameras**, and identifying high-risk locations using geospatial analysis and machine learning.

All major data processing, modeling, and analysis are implemented in Python. This is **not** an Excel-based project.

---

## What This Project Covers
- Cleaning and standardizing large crash datasets (300k+ records)
- Geospatially linking crashes to nearby traffic cameras
- Pre/Post analysis around camera installation dates
- Difference-in-Differences style comparisons
- Machine learning models to predict crash reduction
- Hotspot and blindspot detection for enforcement planning
- Model comparison across multiple algorithms

---

## Data
Public datasets from **DC Open Data**, including:
- Traffic crash records (location, date, severity)
- Automated traffic enforcement camera locations and activation dates
- Weather-enriched crash data (merged externally)

> Raw datasets are not included in this repository due to size.

---

## Tools & Technologies
- **Python**
  - pandas, numpy
  - matplotlib, seaborn
  - scikit-learn
- **Geospatial Analytics**
  - Haversine distance
  - BallTree nearest-neighbor search
- **Machine Learning**
  - Logistic Regression
  - Random Forest
  - CatBoost (tuned)
- **Model Evaluation**
  - F1-score
  - ROC-AUC
  - Precision / Recall
- **Environment**
  - Jupyter Notebook

---

## Analysis Components
### 1. Data Cleaning & Preparation
- Standardized column names and formats
- Parsed dates and validated geographic coordinates
- Constructed binary crash severity indicators

### 2. Camera–Crash Linking
- Linked crashes to nearest enforcement camera (≤100m)
- Used BallTree with haversine distance for scalability

### 3. Pre/Post & DiD Analysis
- Compared crash outcomes before and after camera installation
- Evaluated changes in crash frequency and severity
- Grouped results by enforcement type

### 4. Machine Learning Models
- Target: whether crashes decrease after camera installation
- Features include pre-install crash volume, severity, and camera type
- Models:
  - Logistic Regression (baseline & balanced)
  - Random Forest
  - CatBoost (tuned)
- Evaluated using F1-score and ROC-AUC

### 5. Hotspots & Blindspots
- Identified recent high-severity crash clusters
- Focused on locations **without nearby enforcement**
- Ranked wards and spatial grid cells by risk

### 6. Model Comparison
- Side-by-side evaluation of ML models
- Tradeoffs between interpretability and predictive performance

---

