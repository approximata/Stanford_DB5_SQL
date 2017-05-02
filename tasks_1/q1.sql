/*Q1 Find the titles of all movies directed by Steven Spielberg. */

SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';


/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.  */

SELECT distinct year
FROM Movie join Rating
ON Movie.mID = Rating.mID
WHERE Rating.stars >= 4
ORDER BY year;


/* Find the titles of all movies that have no ratings.   */

SELECT  Movie.title
FROM Movie left join Rating using(mID)
WHERE Rating.mID is null;


/* Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.   */

SELECT  Reviewer.name
FROM Reviewer join Rating using(rID)
WHERE Rating.ratingDate is null;


/* Write a query to return the ratings data in a more readable format:
reviewer name, movie title, stars, and ratingDate.
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.    */

SELECT  Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
FROM Reviewer join Rating join Movie
ON Reviewer.rID = Rating.rID and Rating.mID = Movie.mID
ORDER BY Reviewer.name, Movie.title, Rating.stars ;


/* For all cases where the same reviewer rated the same movie twice
and gave it a higher rating the second time,
return the reviewer's name and the title of the movie.     */

SELECT Reviewer.name, Movie.title
From Reviewer join
(SELECT distinct R1.rID, R1.mID
FROM Rating R1, Rating R2
WHERE R1.rID = R2.rID and R1.mID = R2.mID and ((R1.ratingDate > R2.ratingDate and R1.stars > R2.stars) or (R2.ratingDate > R1.ratingDate and R2.stars > R1.stars) )) R
join Movie
ON Reviewer.rID = R.rID and R.mID = Movie.mID;


/* For each movie that has at least one rating, find the highest number of stars that movie received.
Return the movie title and number of stars. Sort by movie title.    */

SELECT distinct Movie.title, max(Rating.stars)
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY Movie.title;


/*For each movie, return the title and the 'rating spread',
that is, the difference between highest and lowest ratings given to that movie.
Sort by rating spread from highest to lowest, then by movie title.   */

SELECT distinct Movie.title, max(Rating.stars) - min(Rating.stars) as RS
FROM Rating, Movie
WHERE Rating.mID = Movie.mID
GROUP BY Rating.mID
ORDER BY RS DESC, Movie.title;


/*Find the difference between the average rating of movies released before 1980
 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
 */

SELECT avg(MABS80U) -  avg(MABS80A)
FROM (SELECT avg(Rating.stars)  as MABS80U
FROM Rating, Movie
WHERE Rating.mID = Movie.mID AND Movie.year < 1980
GROUP BY Rating.mID) as MABS1,
(SELECT avg(Rating.stars)  as MABS80A
FROM Rating, Movie
WHERE Rating.mID = Movie.mID AND Movie.year >= 1980
GROUP BY Rating.mID) as MABS2
