


  USE CampusX

  SELECT * FROM olympics

  --Rename Tables name--- 
  sp_rename 'olympics_cleaned_v4',  'olympics';

--Problem 1
--Display the names of athletes who won a gold medal in the 2008 Olympics and whose height is greater than the average height of all athletes in the 2008 Olympics.

SELECT *FROM olympics
WHERE Medal = 'Gold' AND Year = 2008 AND Height> (SELECT AVG(Height) 
                                                    FROM olympics 
						     WHERE Year = 2008)


--Problem 2
--Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics and whose weight is less than the average weight of all athletes who won a medal in the 2016 Olympics.

SELECT * FROM olympics
WHERE Sport= 'Basketball' AND Year= 2016 AND Weight < (SELECT AVG(Weight) FROM olympics WHERE Year= 2016) AND Medal IS NOT NULL


--Problem 3
--Display the names of all athletes who have won a medal in the sport of swimming in both the 2008 and 2016 Olympics.

SELECT * FROM olympics
WHERE Sport= 'Swimming'  AND Year IN (2008,2016) AND Medal IS NOT NULL


--Problem 4  
--Display the names of all countries that have won more than 50 medals in a single year.

SELECT country, Year, Count(Medal) AS Num_Medals FROM Olympics
GROUP BY country, Year
HAVING Count(Medal) > 50
ORDER BY Year,Num_Medals DESC


--Problem 5
--Display the names of all athletes who have won medals in more than one sport in the same year.

SELECT Name,Year,Sport AS Sports, Count(Event)AS Events, COUNT(Medal) AS Medals FROM Olympics
GROUP BY Name,year, Sport
HAVING COUNT(Sport) >1 AND COUNT(Medal)>1
ORDER BY Year ASC


--Problem 6
--What is the average weight difference between male and female athletes in the Olympics who have won a medal in the same event?

SELECT 
    AVG(abs(male.weight - female.weight)) AS avg_weight_difference
FROM 
    Olympics  AS male
    JOIN Olympics  AS female ON male.event = female.event
     WHERE  male.sex = 'M' 
     AND female.sex = 'F'
     AND male.medal IS NOT NULL
     AND female.medal IS NOT NULL;

