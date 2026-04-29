# customer-churn-analysis-sql

## Goal

Identify key behavioral and financial drivers of customer churn in a subscription-based digital product and provide actionable insights to improve retention.


## Approach

Performed exploratory data analysis using SQL on ~440k customer records
Compared churned vs retained users across engagement, support, and payment behavior
Built customer segments based on support interaction, payment delay, and customer value
Analyzed combined segments to identify high-risk customer profiles

## Key Findings

* Support interaction is the strongest churn driver, with high-support customers showing a 100% churn rate across all segments
* Payment delay exhibits a threshold effect: churn remains stable (~46%) at low/medium levels but jumps to 100% in high-delay segments
* Churn risk increases significantly when multiple risk factors are combined, indicating strong interaction effects
* Customer value does not offset poor experience — even high-spend users churn when support interaction is high
* Low-value customers show significantly higher churn (~87%), indicating weak engagement or poor product fit
* The most stable segment consists of customers with low support interaction and low payment delay (~22% churn)
* Several segments show 100% churn, suggesting either strong behavioral patterns or potential data limitations

## Dataset

The dataset contains ~440k customer records with demographic, behavioral, and subscription-related features, including usage, support interactions, payment behavior, and churn status.

## Project Structure


customer-churn-analysis-sql/
├── README.md
├── data/
│ └── customer_churn_dataset.csv
├── sql/
│ └── churn_analysis.sql
├── powerbi/
│ └── churn_dashboard.pbix
└── images/
├── churn_overview.png
├── support_vs_churn.png
└── segments_heatmap.png

