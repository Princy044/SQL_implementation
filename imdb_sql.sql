USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Rows = 3867
SELECT COUNT(*) FROM GENRE ;
-- Rows = 14662
SELECT COUNT(*) FROM  MOVIE;
-- Rows = 7997
SELECT COUNT(*) FROM  NAMES;
-- Rows = 25735
SELECT COUNT(*) FROM  RATINGS;
-- Rows = 7997
SELECT COUNT(*) FROM  ROLE_MAPPING;
-- Rows = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- select count(*), count(id), count(name), count(year), count(rankscore)
-- from movie;

with null_values as (
	SELECT 
	case when id is null then 1 else 0 end as null_id,
	case when title is null then 1 else 0 end as null_title,
	case when year is null then 1 else 0 end as null_year,
	case when date_published is null then 1 else 0 end as null_date,
	case when duration is null then 1 else 0 end as null_duration,
	case when country is null then 1 else 0 end as null_country,
	case when worlwide_gross_income is null then 1 else 0 end as null_wgi,
	case when languages is null then 1 else 0 end as null_lng,
	case when production_company is null then 1 else 0 end as null_pc
	from movie
) select sum(null_id) id_null_count,
sum(null_title) title_null_count, sum(null_year) year_null_count, sum(null_date) date_null_count,
sum(null_duration) duration_null_count, sum(null_country) country_null_count, 
sum(null_wgi) worldwide_gross_null_count, sum(null_lng) language_null_count,
sum(null_pc) production_company_null_count
from null_values;
-- select * from null_values;

-- Country, worlwide_gross_income, languages and production_company columns have NULL values



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year, count(id) number_of_movies 
from movie
group by year 
order by year;

-- Total Number of movies released each year are 2017:3052  , 2018:2944 , 2019:2001

select 
	month(date_published) month_num, 
	count(id) number_of_movies from movie
group by month(date_published) 
order by month(date_published);

-- Highest number of movies is produced in the month of March : 824 movies.	



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select "USA or India" country, year, count( title) movie_count
from movie
where 
	(country LIKE '%INDIA%' OR country LIKE '%USA%') 
    and year =2019
group by year;

-- 1059 movies were produced in the USA or India in the year 2019










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select genre 
from genre 
group by genre;










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(movie_id) movie_count
from genre 
group by genre
order by count(movie_id) desc
limit 1;

-- 4285 Drama movies were produced in total and are the highest among all genres. 






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with movie_genre_count as(
	select movie_id , count(genre) count_genre from genre
	group by movie_id
	order by count(genre) desc)
select count(movie_id) movies_with_one_genre from movie_genre_count
where count_genre= 1;

-- 3289 movies belong to only one genre




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select g.genre, round(avg(m.duration),2) avg_duration
from genre g 
inner join movie m
	on g.movie_id= m.id
group by g.genre
order by avg_duration desc;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_rank as(
select genre, count(movie_id) movie_count,
rank() over (order by count(movie_id) desc) as genre_rank
from genre 
group by genre)
select * from genre_rank 
where genre= 'thriller';

-- Thriller has rank=3 and movie count of 1484


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
	min(avg_rating) min_avg_rating ,
	max(avg_rating) max_avg_rating,
	min(total_votes) min_total_votes,
	max(total_votes) max_total_votes,
	min(median_rating) min_median_rating,
	max(median_rating) max_median_rating
from ratings;

/*MIN_AVG_RATING - 1.0
MAX_AVG_RATING - 10.0
MIN_TOTAL_VOTES - 100
MAX_TOTAL_VOTES - 725138
MIN_MEDIAN_RATING - 1
MAX_MEDIAN_RATING - 10
The minimum and maximum values in each column of the ratings table are in the expected range.*/  



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with rating_movie_rank as(
	select m.title, r.avg_rating , 
		rank() over(order by r.avg_rating desc) as movie_rank
	from ratings r
	inner join movie m
		on r.movie_id = m.id)
select * from rating_movie_rank
where movie_rank <=10;

-- Top 2 movies have average rating 10




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating, count(movie_id) movie_count
from ratings 
group by median_rating 
order by count(movie_id) desc, median_rating desc;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

with production_rating as(
	select 
		m.production_company, count(r.movie_id) movie_count,
		rank() over (order by  count(r.movie_id) desc) as prod_company_rank 
	from movie m
	inner join ratings r
		on r.movie_id = m.id 
	where r.avg_rating >8 and m.production_company is not null
	group by m.production_company
)
select * from production_rating where prod_company_rank=1;

-- Dream Warrior Pictures and National Theatre top production company based on superhit movie count
-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, count(m.id) movie_count
from ratings r
inner join genre g
	on r.movie_id = g.movie_id
inner join movie m
	on g.movie_id = m.id
where m.year =2017 
	and month(m.date_published) =3 
    and m.country like '%USA%'
    and r.total_votes >1000
group by g.genre
order by count(m.id) desc;

-- Top 3 genres are drama - 24 , comedy- 9 and action - 8 movie counts during March 2017 in the USA and had more than 1,000 votes




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select m.title, r.avg_rating, g.genre
from movie m
inner join ratings r
	on m.id= r.movie_id
inner join genre g 
	on r.movie_id= g.movie_id
where r.avg_rating>8
	and m.title like 'The%'
order by r.avg_rating desc;


-- There are 15 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select 
	count(m.title) movie_count
from movie m 
inner join ratings r
	on m.id= r.movie_id
where m.date_published between '2018-04-01' and '2019-04-01'
	and r.median_rating=8;

-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

with selected_lang_votes as(
select
case when m.languages like '%German%' then 'German'
	when m.languages like '%Italian%' then 'Italien'
end as selected_country ,
total_votes
from movie m
inner join ratings r 
on m.id = r.movie_id
where m.languages like '%German%'
	or m.languages like'%Italian%')
select selected_country, sum(total_votes) agg_total_votes
from selected_lang_votes
group by selected_country;


-- Total votes  for German= 4421525 and Italien= 2003623



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

with null_info as (
	select 
		case when name is null then 1 else 0 end as name_nulls,
		case when height is null then 1 else 0 end as height_nulls,
		case when date_of_birth is null then 1 else 0 end as dob_nulls,
		case when known_for_movies is null then 1 else 0 end as km_nulls
	from names
) select sum(name_nulls) name_nulls,
	sum(height_nulls) height_nulls,
	sum(dob_nulls) date_of_birth_nulls,
    sum(km_nulls) known_for_movies_nulls
from null_info;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_3_genre as (
	select
		g.genre, count(g.movie_id)
	from genre g
	inner join ratings r
		on g.movie_id = r.movie_id
	where avg_rating>8
	group by genre
	order by count(movie_id) desc
	limit 3
)
select 
	n.name, count(d.movie_id) movie_count
from names n 
inner join director_mapping d
	on n.id= d.name_id
inner join ratings r
	on d.movie_id = r.movie_id
inner join genre g 
	on r.movie_id= g.movie_id
where r.avg_rating >8 
and genre in (select genre from top_3_genre)
group by n.name
order by count(d.movie_id) desc
limit 3;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
	n.name, count(r.movie_id) movie_count
from names n
inner join role_mapping rm
	on n.id = rm.name_id
inner join ratings r
	on rm.movie_id = r.movie_id
where rm.category = 'actor'
and r.median_rating >=8
group by n.name
order by count(r.movie_id) desc
limit 2;

-- Mammootty and Mohanlal are top 2 actors.




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with rank_porduction as(
	select 
		m.production_company, sum(r.total_votes) vote_count, 
		rank() over (order by sum(r.total_votes) desc) as prod_comp_rank
	from movie m
	inner join ratings r
		on m.id= r.movie_id
	group by m.production_company
)
select * from rank_porduction
where prod_comp_rank <=3;

--  Marvel Studios, Twentieth Century Fox and Warner Bros are the top three production houses based on the number of votes received by their movies.






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actor_rating as(
	select  n.name actor_name, rm.name_id, sum(r.total_votes) total_votes, 
		sum(r.avg_rating), count(r.movie_id) movie_count,
		sum(r.avg_rating * r.total_votes)/sum(r.total_votes) as weighted_average from ratings r 
	inner join role_mapping rm
		on r.movie_id = rm.movie_id 
	inner join names n 
		on rm.name_id = n.id
	inner join movie m
		on r.movie_id = m.id
	where rm.category = 'actor'
		and m.country like '%India%'
	group by rm.name_id
	having count(r.movie_id)>=5
)
select actor_name, total_votes, movie_count, weighted_average actor_avg_rating,
	rank() over (order by weighted_average desc, total_votes desc) actor_rank
from actor_rating;

-- Vijay Sethupathi , Fahadh Faasil and Yogi Babu are the top actors with movies released in India based on their average ratings.


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_rating as(
	select  n.name actor_name, rm.name_id, sum(r.total_votes) total_votes, 
		sum(r.avg_rating), count(r.movie_id) movie_count,
		sum(r.avg_rating * r.total_votes)/sum(r.total_votes) as weighted_average from ratings r 
	inner join role_mapping rm
		on r.movie_id = rm.movie_id 
	inner join names n 
		on rm.name_id = n.id
	inner join movie m
		on r.movie_id = m.id
	where rm.category = 'actress'
		and m.country like '%India%'
		and m.languages like '%Hindi%'
	group by rm.name_id
	having count(r.movie_id)>=3
),
actress_rank as (
select actor_name, total_votes, movie_count, round(weighted_average,2) actress_avg_rating,
	rank() over (order by weighted_average desc) actress_rank
from actress_rating)
select * from actress_rank
where actress_rank<=5;

-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda are the top five actresses in Hindi movies released in India based on their average ratings.

-- select languages from movie group by languages


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select m.title, r.avg_rating,
case 
	when r.avg_rating > 8 then 'Superhit movies' 
	when r.avg_rating between 7 and 8 then 'Hit movies'
    when r.avg_rating between 5 and 7 then 'One-time-watch movies'
    else 'Flop movies'
end as rating_category
from movie m 
inner join ratings r 
	on m.id = r.movie_id
inner join genre g 
	on r.movie_id = g.movie_id
where g.genre= 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select g.genre, 
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 5 PRECEDING) AS moving_avg_duration
from genre g 
inner join movie m
	on g.movie_id = m.id
group by g.genre
order by genre;

-- Action movies have highest average duration 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_3_genres as (
	select genre, count(movie_id) movie_count
	from genre 
	group by genre
	order by count(movie_id) desc
	limit 3
),
movie_rank_by_top_genres as (
	SELECT genre,
			year,
			title AS movie_name,
			case 
			when worlwide_gross_income like '%INR%' then CAST(replace(ifnull(worlwide_gross_income,0),'INR','') AS decimal(10)) * 0.012
			else CAST(replace(ifnull(worlwide_gross_income,0),'$','')AS decimal(10)) 
			end as worlwide_gross_income_int
	FROM movie AS m 
	INNER JOIN genre AS g 
		ON m.id= g.movie_id
	WHERE genre IN (select genre from top_3_genres)
),
ranks_by_gross_income as (
	select *, 
	DENSE_RANK() OVER(partition BY year ORDER BY worlwide_gross_income_int DESC ) AS movie_rank
	from movie_rank_by_top_genres 
	order by year
    )
select * from ranks_by_gross_income where movie_rank <=5;

 -- In the year 2017, Thriller movie 'The fate of the furious' has the highest gross income among the top 3 genre  

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with prod_house_multi_ling as (
	SELECT production_company,
			COUNT(m.id) AS movie_count,
			ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
	FROM movie AS m 
	INNER JOIN ratings AS r 
		ON m.id=r.movie_id
	WHERE median_rating>=8 
		AND production_company IS NOT NULL 
		AND POSITION(',' IN languages)>0
	GROUP BY production_company
)
select * from prod_house_multi_ling 
where prod_comp_rank<=2;

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.name actress_name, 
	SUM(r.total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
	avg(r.avg_rating) actress_avg_rating,
	DENSE_RANK() OVER(ORDER BY count(rm.movie_id) DESC, avg(r.avg_rating) desc) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
	ON n.id = rm.name_id
INNER JOIN ratings r
	ON r.movie_id = rm.movie_id
INNER JOIN genre g
	ON r.movie_id = g.movie_id
WHERE rm.category = 'actress' 
	AND r.avg_rating > 8 
    AND g.genre = 'drama'
GROUP BY n.name
limit 3;


-- Parvathy Thiruvothu, Denise Gough and Amanda Lawrence are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with lead_dates as (
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY d.movie_id, date_published) AS next_movie_date
FROM director_mapping d
inner JOIN names AS n 
     ON d.name_id=n.id 
inner JOIN movie AS m 
     ON d.movie_id=m.id),
date_diff_table as (
 SELECT *, DATEDIFF(next_movie_date, date_published) AS date_diff
	 FROM lead_dates),
director_ranks AS
 (
	 SELECT d.name_id director_id,
		 n.name director_name,
		 COUNT(d.movie_id) number_of_movies,
		 ROUND(avg(dif.date_diff),2) inter_movie_days,
		 ROUND(AVG(avg_rating),2) avg_rating,
		 SUM(total_votes) total_votes,
		 MIN(avg_rating) min_rating,
		 MAX(avg_rating) max_rating,
		 SUM(duration) total_duration
		--  ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names n 
         inner JOIN director_mapping AS d 
			ON n.id=d.name_id
		 inner JOIN ratings AS r 
			ON d.movie_id=r.movie_id
		 inner JOIN movie AS m 
			ON m.id=r.movie_id
		 inner JOIN date_diff_table dif
			ON dif.name_id=d.name_id
	 GROUP BY director_id
     order by count(d.movie_id) desc, ROUND(AVG(r.avg_rating),2) desc
 )
 select * from director_ranks
 limit 9;

--  A.L. Vijay and Andrew Jones are the top two directors based on number of movies produced


