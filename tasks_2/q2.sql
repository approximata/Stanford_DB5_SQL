/* Find the names of all students who are friends with someone named Gabriel. */

SELECT H2.name
FROM Friend JOIN Highschooler as H1 JOIN Highschooler as H2
ON Friend.ID1 = H1.ID  AND Friend.ID2 = H2.ID
WHERE H1.name = 'Gabriel'
UNION
SELECT H1.name
FROM Friend JOIN Highschooler as H2 JOIN Highschooler as H1
ON Friend.ID1 = H2.ID  AND Friend.ID2 = H1.ID
WHERE H2.name = 'Gabriel'


/* For every student who likes someone 2 or more grades younger than themselves,
return that student's name and grade, and the name and grade of the student they like.  */

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Likes JOIN Highschooler as H1 JOIN Highschooler as H2
ON Likes.ID1 = H1.ID  AND Likes.ID2 = H2.ID
WHERE H1.grade - H2.grade >= 2;


/* For every pair of students who both like each other,
 return the name and grade of both students.
 Include each pair only once, with the two names in alphabetical order.   */


/*solution 1 */
SELECT H1.name,  H1.Grade, H2.name, H2.Grade
FROM Highschooler H1 JOIN
(SELECT L1.ID1 as L1ID1, L1.ID2 as L1ID2, L2.ID1 as L2ID1, L2.ID2 as L2ID2
FROM Likes as L1 LEFT JOIN Likes as L2
ON L2.ID2 = L1.ID1
WHERE L1ID1 = L2ID2 and L1ID2 = L2ID1 and L1ID1 < L2ID1) LIKEVER
JOIN
Highschooler H2
ON H1.ID = LIKEVER.L1ID1 and H2.ID = LIKEVER.L1ID2

/*solution 2 */
SELECT H1.name,  H1.Grade, H2.name, H2.Grade
FROM Likes L1 JOIN Likes L2 JOIN Highschooler H1 JOIN Highschooler H2
ON L2.ID2 = L1.ID1 AND L1.ID1 = H1.ID AND L2.ID1 = H2.ID
WHERE L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1 and H1.name < H2.name;


/* Find all students who do not appear
in the Likes table
(as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
   */

SELECT Highschooler.name, Highschooler.grade
FROM Highschooler
EXCEPT
SELECT Highschooler.name, Highschooler.grade
FROM Highschooler JOIN
(SELECT L1.ID1 as ID
FROM Likes L1
UNION
SELECT L2.ID2 as ID
FROM Likes L2 ) ALLLIKE
ON Highschooler.ID = ALLLIKE.ID
ORDER BY Highschooler.grade, Highschooler.name


/* For every situation where student A likes student B,
but we have no information about whom B likes
(that is, B does not appear as an ID1 in the Likes table),
return A and B's names and grades.
   */

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM
Highschooler H1 JOIN
(SELECT L1.ID1 as L1ID1, L1.ID2 as L1ID2
FROM Likes L1 LEFT JOIN Likes L2
ON L1.ID2 = L2.ID1
WHERE L2.ID1 IS NULL)  NOLIKES
JOIN
Highschooler H2
ON H1.ID = NOLIKES.L1ID1 AND H2.ID =  NOLIKES.L1ID2


 /* Find names and grades of students who only have friends in the same grade.
 Return the result sorted by grade, then by name within each grade.
    */

 SELECT Highschooler.name, Highschooler.grade
 FROM Highschooler
 WHERE Highschooler.ID IN
 (SELECT F1.ID1
 FROM Friend F1 JOIN Highschooler H1 JOIN Highschooler H2
 ON H1.ID = F1.ID1 AND H2.ID = F1.ID2
 WHERE H1.grade = H2.grade)
 AND
 Highschooler.ID NOT IN
 (SELECT F1.ID1
 FROM Friend F1 JOIN Highschooler H1 JOIN Highschooler H2
 ON H1.ID = F1.ID1 AND H2.ID = F1.ID2
 WHERE H1.grade <> H2.grade)
 ORDER BY Highschooler.grade, Highschooler.name;


 /*For each student A who likes a student B where the two are not friends,
 find if they have a friend C in common (who can introduce them!).
 For all such trios, return the name and grade of A, B, and C.  */

 SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
 FROM
 (SELECT *
 FROM Likes
 WHERE Likes.ID1 NOT IN
 (SELECT Friend.ID1 FROM Friend WHERE Likes.ID2 = Friend.ID2)) NOTF
 JOIN
 (SELECT F1.ID1 AS WHOLIKE, F2.ID2 AS WHOMLIKED, F1.ID2 AS COMMON
 FROM Friend F1, Friend F2
 WHERE F1.ID1 <> F2.ID2 AND F1.ID2 = F2.ID1) COMMONF
 JOIN
 Highschooler H1
 JOIN
 Highschooler H2
 JOIN
 Highschooler H3
 ON NOTF.ID1 = COMMONF.WHOLIKE AND NOTF.ID2 = COMMONF.WHOMLIKED AND H1.ID = NOTF.ID1 AND H2.ID = NOTF.ID2 AND H3.ID =  COMMONF.COMMON;


 /*Find the difference between the number of students in the school and the number of different first names.  */

 SELECT COUNT(ID) - COUNT(DISTINCT name)
 FROM Highschooler


 /*Find the name and grade of all students who are
liked by more than one other student. */

SELECT Highschooler.name, Highschooler.grade
FROM Likes JOIN Highschooler
ON Highschooler.ID = Likes.ID2
GROUP BY LIKES.ID2
HAVING Count(Likes.ID1) > 1
