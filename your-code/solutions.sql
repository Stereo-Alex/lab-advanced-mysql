USE publications;

select * from authors;
select * from titles;
select * from sales;
select * from titleauthor;
select * from publishers;

-- Challenge 1, Step 1 

SELECT
	ta.au_id,	
    ta.title_id, 
    (t.advance * ta.royaltyper/100) AS advance_au, 
    (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS sales_royalty 
    
FROM
	titles t,
    titleauthor ta,
    sales s;
    
-- Step 2 

SELECT 
    QUER1.au_id,   QUER1.title_id, SUM(advance_au), SUM(sales_royalty)
FROM
    (SELECT 
        ta.au_id,
		ta.title_id,
            (t.advance * ta.royaltyper / 100) AS advance_au,
            (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
    FROM
        titles t, titleauthor ta, sales s) QUER1
        
GROUP BY   QUER1.au_id ,  QUER1.title_id;

-- Step 3

SELECT 
    q1.au_id, sum(q1.total1) as total
FROM
    (SELECT 
        q2.au_id,
            q2.title_id,
            SUM(advance_au) + SUM(sales_royalty) AS total1
    FROM
        (SELECT 
        ta.au_id,
            ta.title_id,
            (t.advance * ta.royaltyper / 100) AS advance_au,
            (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
    FROM
        titles t, titleauthor ta, sales s) q2
    GROUP BY q2.au_id , q2.title_id) q1
GROUP BY q1.au_id
ORDER BY total DESC
LIMIT  3 ;

-- Challenge 2 
CREATE TEMPORARY TABLE q2
SELECT
	ta.au_id,	
    ta.title_id,
    (t.advance * ta.royaltyper/100) AS advance_au,
    (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS sales_royalty
FROM
	titles t,
    titleauthor ta,
    sales s;
    
CREATE TEMPORARY TABLE q1
SELECT q2.au_id, q2.title_id, SUM(advance_au) + SUM(sales_royalty) as total_pre FROM q2
GROUP BY q2.au_id, q2.title_id;

SELECT 
    q1.au_id, SUM(total_pre) AS Total
FROM
    q1
GROUP BY q1.au_id
ORDER BY Total DESC
LIMIT 3;


-- Challenge 3 
DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE most_profiting_authors AS

SELECT 
    q1.au_id AS 'Author ID',
    SUM(total_pre) AS 'Profits'
FROM
    q1
GROUP BY q1.au_id
ORDER BY SUM(total_pre) DESC
LIMIT 3;

Select * from most_profiting_authors;



