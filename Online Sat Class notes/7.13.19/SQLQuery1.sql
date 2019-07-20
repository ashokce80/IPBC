Create Table Rate(
				RateID int primary key
				,ContainerLength int 
				,OriginPort varchar(10)
				,DestPort varchar(10)
				,Amount money not null)

Select	*
From	Rate




-- ans to first doc file

SELECT A.ContainerNumber, count(C.VoyageID)
FROM Container A
LEFT JOIN ContainerVoyage B
ON A.ContainerID = B.ContainerID
INNER JOIN Voyage C
ON B.VoyageID = C.VoyageID
group by A.ContainerNumber


SELECT ContainerNumber 
FROM Container
WHERE ContainerNumber NOT IN
(
SELECT DISTINCT A.ContainerNumber
FROM Container A
LEFT JOIN ContainerVoyage B
ON A.ContainerID = B.ContainerID
INNER JOIN Voyage C
ON B.VoyageID = C.VoyageID
group by A.ContainerNumber
having count(B.VoyageID) = 1
) 
