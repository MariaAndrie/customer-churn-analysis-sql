select database();
create database customer_db;
use customer_db;

select * from customer
limit 100;

-- rename columns to snake_case for clean and readable SQL queries
alter table customer rename column `Usage Frequency` to Usage_frequency;
alter table customer rename column `Support Calls` to Support_calls;
alter table customer rename column `Payment Delay` to Payment_delay;
alter table customer rename column `Subscription Type` to Subscription_type;
alter table customer rename column `Contract Length` to Contract_length;
alter table customer rename column `Total Spend` to Total_spend;
alter table customer rename column `Last Interaction` to Last_interaction


-- check total number of rows after import
select count(*) from customer;

-- Result
-- 440832

-- check for duplicates
select count(distinct customerID) from customer;

-- Result
-- 440832

-- The dataset contains 440832 records and 440832 unique customers, indicating absence of duplicate or repeated customer entries.

-- check churn distribution
select churn, count(*) as users from customer
group by churn;

-- Results
-- churn users
-- 1	249999
-- 0	190833

-- the dataset shows a relatively balanced churn distribution (~57% churn), making it suitable for behavioral analysis and comparison between customer groups.

-- compare key behavioral metrics between churned and retained users
select 
	churn, 
	round(avg(usage_frequency),2) as avg_usage,
	round(avg(tenure),2) as avg_tenure,
	round(avg(support_calls),2) as avg_support_calls,
	round(avg(Payment_delay),2) as avg_payment_delay,
	round(avg(Total_spend),2) as avg_total_spent
from customer
group by churn; 

-- Results
-- churn avg_usage avg_tenure avg_support_calls avg_payment_delay avg_total_spent
-- 1	 15.46	   30.47	  5.14	            15.22	          541.29
-- 0	 16.26	   32.28	  1.59	            10.02	          749.96

/* 
=========================================
	Findings
=========================================
	* Support Calls
	5.14 vs 1.59
	Customers who churn have significantly higher support interaction, suggesting that unresolved issues or poor customer experience are a major driver of churn.
	* Payment Delay
	15.22 vs 10.02
	Customers with frequent payment delays are more likely to churn, indicating financial friction or disengagement.
	* Total Spend
	541 vs 750
	Higher-spending customers are less likely to churn, suggesting that more engaged or valuable users tend to stay.
	* Usage
	15.46 vs 16.26
	Usage frequency shows only a minor difference between groups, suggesting that engagement alone may not be a strong predictor of churn in this dataset.
	* Tenure
	30 vs 32
	Customer tenure has a limited impact on churn, indicating that users leave at various stages of the lifecycle. 
*/
    
    --  to find segmentation thresholds    
     select support_calls, count(*)
     from customer
     group by support_calls
     order by support_calls;
 
	-- segment customers by number of support calls to identify high-risk groups
    select 
		case 
			when support_calls <=2 then 'low_support'
            when support_calls <=6 then 'medium_support'
            else 'high_support'
		end as support_segment,
        count(*) as users,
        round(avg(churn)*100,2) as churn_rate
	from customer
    group by support_segment
    order by churn_rate desc;
    
    
/*
Results
support_segment users   churn_rate
high_support	94959	100.00
medium_support	139951	65.58
low_support	    205922	30.72
      
=========================================
	Findings
=========================================
	* Churn risk increases sharply with the number of support interactions, rising from ~31% (low) to over 65% (medium) and reaching 100% in the high-support segment  
	* Customers with high support usage show a complete churn outcome, indicating a potential “point of no return” in customer experience  
	* The strong gradient suggests that support interactions are a critical early warning signal for churn  
*/
       
    --  to find segmentation thresholds     
	select payment_delay, count(*) as user from customer
	group by payment_delay
	order by payment_delay;
    -- Segmentation thresholds were defined based on the distribution of payment delays, where a clear drop in frequency occurs after 20 days, indicating a shift to abnormal customer behavior.

    -- segment customers by payment delay to analyze churn risk
    select
		case
			when payment_delay <=10 then 'low_delay'
            when payment_delay <=20 then 'medium_delay'
            else 'high_delay'
		end as payment_segment,
	count(*) as users,
    round(avg(churn)*100,2) as churn_rate
    from customer
    group by payment_segment
    order by churn_rate desc;

/*    
Results
payment_segment users 	churn_rate
high_delay		84030	100.00
medium_delay	170555	46.52
low_delay		186247	46.51

=========================================
	Findings
=========================================
    * Payment delay shows a threshold effect: churn remains stable (~46%) across low and medium delay levels, but jumps to 100% in the high-delay segment  
	* This suggests that moderate payment delays do not significantly impact retention, while extreme delays are strongly associated with churn  
*/
    
    -- explore total spend distribution
	select 
		min(total_spend),
		max(total_spend),
		round(avg(total_spend),2)
	from customer;

	select 
	spend_group,
	count(*) as users,
	max(total_spend)
	from (
	select 
		churn,
		total_spend,
		ntile(3) over (order by total_spend) as spend_group
	from customer
	) t
	group by spend_group
	order by spend_group;
/*
Results
spend_group users 	max(total_spend)
1			146944	547
2			146944	774
3			146944	1000
*/

-- segment customers by total spend to analyze churn by customer value
    
    select 
		case
			when total_spend <=550 then 'low_spend'
            when total_spend <=775 then 'medium_spend'
            else 'high_spend'
		end as spend_segment,
	count(*) as users, round(avg(churn),2)*100 as churn_rate	
	from customer
    group by spend_segment
    order by churn_rate desc;

/*

result
spend_segment 	users 	churn_rate
low_spend		148905	87.00
high_spend		145830	41.00
medium_spend	146097	41.00

=========================================
	Findings
=========================================
* Low-value customers churn significantly more often (~87%), indicating low engagement or weak product fit.
* There is no significant difference in churn between medium- and high-value customers (~41%), suggesting 
that higher spend does not necessarily improve retention beyond a certain point.
*/

-- Evaluate how contract length impacts customer churn
select
    contract_length,
    count(*) as users,
    round(avg(churn)*100,2) as churn_rate
from customer
group by contract_length
order by churn_rate desc;

/*
Result

contract_length	users	churn_rate
Monthly			87104	100.00
Annual			177198	46.08
Quarterly		176530	46.03


=========================================
	Findings
=========================================
* Monthly contracts show a 100% churn rate, compared with ~46% for annual and quarterly contracts
* Longer contract commitments are associated with stronger retention
* This suggests that encouraging customers to move from monthly to longer-term plans could improve retention
* Customers on monthly contracts churn 3x more than annual contracts


*/


-- -- Evaluate churn risk and revenue contribution by subscription plan
select
	subscription_type,
    count(*) as users,
    round(avg(churn),2)*100 as churn_rate,
    round(avg(total_spend),2) as avg_spend
from customer
group by subscription_type
order by churn_rate desc;

/*
Result

subscription_plan	users	churn_rate	avg_spend
Basic				143026	58.00		628.68
Standard			149128	56.00		633.14
Premium				148678	56.00		632.93

=========================================
	Findings
=========================================
* Churn rates are very similar across subscription plans, ranging from ~56% to ~58%
* Average spend is also nearly identical across Basic, Standard, and Premium plans.
* Subscription type does not appear to be a major churn differentiator in this dataset

*/


-- combine support and payment segments to identify highest-risk customer groups
select 
	case
		when support_calls <= 2 then 'low_support'
		when support_calls <=6 then 'medium_support'
		else 'high_support'
	end as support_segment,
    case
		when total_spend <=550 then 'low_spend'
		when total_spend <=775 then 'medium_spend'
		else 'high_spend'
	end as spend_segment,
count(*) as users,
round(avg(churn)*100) as churn_rate
from customer
group by support_segment, spend_segment
order by churn_rate desc;

/* Result
support_segment spend_segment 	users 	churn_rate
high_support	medium_spend	23581	100
high_support	low_spend		47588	100
high_support	high_spend		23790	100
medium_support	low_spend		51962	91
low_support		low_spend		49355	71
medium_support	medium_spend	43873	51
medium_support	high_spend		44116	50
low_support		high_spend		77924	18
low_support		medium_spend	78643	18

=========================================
	Findings
=========================================
*Support interactions completely dominate churn behavior, overriding customer value.	
*Even high-value customers churn when support interaction is high, indicating that poor customer experience outweighs customer value.
*Low-value customers show high churn even with low support interaction, suggesting weak engagement or poor product fit.
*Customers with moderate value and low support interaction represent the most stable segment.
*/


select
	case
		when support_calls <=2 then 'low_support'
        when support_calls <=6 then 'medium_support'
        else 'high_support'
	end as support_segment,
    case
		when payment_delay <= 10 then 'low_delay'
        when payment_delay <= 20 then 'medium_delay'
        else 'high_delay'
	end as payment_segment,
    count(*) as users,
    round(avg(churn),2)*100 as churn_rate
    from customer
    group by support_segment, payment_segment
    order by churn_rate desc;

/*   
Results 
support_segment payment_segment users 	churn_rate
high_support	low_delay		33525	100.00
high_support	high_delay		30632	100.00
low_support		high_delay		22960	100.00
medium_support	high_delay		30438	100.00
high_support	medium_delay	30802	100.00
medium_support	medium_delay	52204	56.00
medium_support	low_delay		57309	56.00
low_support		medium_delay	87549	22.00
low_support		low_delay		95413	22.00

=========================================
	Findings
=========================================
* Support interaction is the strongest churn indicator
* Extreme payment delays independently drive churn, even among otherwise low-risk customers
* Customers with low support interaction and low payment delay represent the most stable segment
*/

-- view for PowerBI visualization
create view customer_segments as
select 
	customerID,
    age,
    gender,
    tenure,
    usage_frequency,
    support_calls,
    payment_delay,
    subscription_type,
    contract_length,
    total_spend,
    last_interaction,
    churn,
    case
		when support_calls <=2 then 'low_support'
        when support_calls <=6 then 'medium_support'
        else 'high_support'
	end as support_segment,
    case
		when payment_delay <= 10 then 'low_delay'
        when payment_delay <= 20 then 'medium_delay'
        else 'high_delay'
	end as payment_segment,
    case
		when total_spend <=550 then 'low_spend'
		when total_spend <=775 then 'medium_spend'
		else 'high_spend'
	end as spend_segment
from customer;
    
select * from customer_segments limit 5;
