SELECT * FROM goldusers_signup
SELECT * FROM product
SELECT * FROM sales
SELECT * FROM users 
     
(Q1) What is the total amount each customer spent on zomato?

SELECT sales.userid ,sum(product.price) AS total_expenditure_by_customer
FROM sales
INNER JOIN product 
ON sales.product_id=product.product_id
GROUP BY sales.userid
ORDER BY sales.userid


(Q2) How many days each customer visited zomato?

SELECT userid,count(created_date) AS number_of_days_customer_visited
FROM sales
GROUP BY sales.userid
ORDER BY userid


(Q3) What was the first product purchased by each customer?

SELECT * FROM
(SELECT *,RANK() OVER(PARTITION BY userid ORDER BY created_date) rank FROM sales) sales 
WHERE rank=1

(Q4) What is the most purchased on the menu and how many times was it purcgased by all customer?

SELECT userid, count(product_id) from sales where product_id=
(SELECT product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC LIMIT 1)
GROUP BY userid

(Q5) Which item was the most popular for each customer?
select * from
(select *,rank() over(partition by userid order by cnt desc) rnk from
(select userid,product_id,count(product_id) cnt from sales group by userid,product_id)a)b
where rnk=1
(Q6) Which item was purchased first by the customer after they became a member?
select * from
(select c.*,rank() over(partition by userid order by created_date) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date)c) d
 where rnk=1
 (Q7) which item was purchased just before the customer became a member?
 select * from
(select c.*,rank() over(partition by userid order by created_date desc) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date)c) d
 where rnk=1
 (Q8) What is the total orders and amount spent for each member before they became a member?
  select userid,count(created_date),sum(price) total_amt_spent from
 (select c.*,d.price from
 (select a.userid, a.created_date,a.product_id,b.gold_signup_date from sales a inner join
  goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date) c inner join
  product d on c.product_id=d.product_id)
  e group by userid
 (Q9) if buying each product points for eg 5rs=2 zomato points and each product has different purchasing points for eg for p1 5rs=1 zomato point , for p2 10rs=5 zomato point and p3 5rs=1 zomato point 
       calculate points collected by each customer?
	select userid,sum(total_points)*2.5 total_money_earned from
	(select e.*,amt/points total_points from
	(select d.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from 
	(select c.userid,c.product_id,sum(price) amt from
	(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)
	 c group by userid,product_id)d)e)f group by userid
	
	
(Q10) rank all the transaction of the customers?
    select *,rank() over(partition by userid order by created_date) rank from sales
	

