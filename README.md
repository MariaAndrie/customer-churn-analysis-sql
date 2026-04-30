# Customer Churn Risk Analysis with SQL & Power BI


## Project Overview

This project analyzes customer churn in a subscription-based digital product using SQL and Power BI. 
The goal is to identify customer behaviors and segments that are most strongly associated with churn, then translate those findings into actionable retention recommendations.
The analysis focuses on support interactions, payment delays, customer spend, contract length, and subscription type.


## Approach

Performed exploratory data analysis using SQL on ~440k customer records
Compared churned vs retained users across engagement, support, and payment behavior
Built customer segments based on support interaction, payment delay, and customer value
Analyzed combined segments to identify high-risk customer profiles


## Business Goal

Customer churn directly impacts recurring revenue and long-term customer value. By identifying high-risk customer segments, the business can prioritize retention efforts, improve customer experience, and reduce preventable churn.

This project answers the following questions:

- Which customer behaviors are most associated with churn?
- Do support calls, payment delays, or spend levels signal higher churn risk?
- Are high-value customers protected from churn?
- Which customer segments should retention teams prioritize?
- Does contract length or subscription type affect churn risk?


## Key Findings
 
* Support interaction is the strongest observable indicator of churn in this dataset, with higher support usage strongly associated with increased churn risk.
* Payment delay shows a threshold effect: moderate delays have limited impact, while extreme delays are strongly associated with churn.
* Low-spend customers are significantly more likely to churn, suggesting weaker engagement or lower perceived value.
* Contract structure plays a key role in retention, with shorter-term contracts associated with higher churn risk.
* Subscription type does not significantly differentiate churn behavior, as churn rates remain similar across plans.
* Customer experience outweighs customer value, as even high-spend customers churn when support interaction is high.
* Combined risk factors amplify churn probability, with customers exhibiting multiple risk signals showing the highest churn rates.
* The most stable customers are those with low support interaction and low payment delay, indicating consistent engagement and smooth payment behavior.
* Several segments exhibit extremely high churn rates, suggesting strong behavioral patterns but also requiring validation for potential data limitations.


## Business Recommendations

Based on the analysis, the business should:

* Prioritize customers with high support interaction for immediate retention outreach  
* Investigate root causes behind repeated support calls to improve customer experience  
* Implement early-warning alerts when customers exceed a critical number of support interactions  
* Closely monitor customers with significant payment delays and introduce proactive payment support  
* Encourage customers to switch from monthly to longer-term contracts to improve retention  
* Design engagement strategies for low-spend customers to increase perceived value  
* Track high-value customers with increasing support activity, as they remain at risk despite high spend  


## Power BI Dashboard

The dashboard was designed to help stakeholders quickly identify churn patterns and high-risk customer segments.

Key components include:
- Executive overview with total customers, churn rate, and key KPIs  
- Churn breakdown by support interaction, payment delay, and spend segments  
- Customer risk segmentation matrices (support vs spend, support vs payment delay)  
- Identification of highest-risk customer groups for retention prioritization 


## Dataset

The dataset contains ~440k customer records with demographic, behavioral, and subscription-related features, including usage, support interactions, payment behavior, and churn status.


## Tools Used

- SQL: data validation, exploratory analysis, segmentation, and view creation
- Power BI: dashboard design and visual storytelling
- GitHub: project documentation


## Project Structure

```
customer-churn-analysis-sql/
├── README.md
├── data/
│ └── customer_churn_dataset.csv
├── sql/
│ └── churn_analysis.sql
├── powerbi/
│ └── churn_dashboard.pbix
└── images/
│└── churn_overview.png
```

## Conclusion

The analysis shows that churn is most strongly associated with support interaction, payment delay, customer spend, and contract length. 
Support calls are the clearest behavioral warning signal, while monthly contracts and high payment delays represent major risk segments.
The key business takeaway is that customer experience matters more than customer value: even high-spend customers churn when support interaction is high.

