use coolkids;

# Create school profile
#before
SELECT SchoolName,  City, Philosophy FROM School JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE DistrictName = 'Alameda';  

#insert
INSERT INTO School (SchoolName, Street, City, Zip, idDistrict, Type, TSratio, Philosophy, Tuition)
VALUES ('Fuzzy Caterpillar Preschool', '1510 Encinal Ave', 'Alameda', 94501, 1,'private', '20:1', 'play-based', 1580);

#after
SELECT SchoolName,  City, Philosophy FROM School JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE DistrictName = 'Alameda';  

#Congregation Beth Sholom Family Preschool wants to know if there's any appointment not confirmed yet.
SELECT Appointment.* FROM Appointment JOIN School ON Appointment.idSchool = School.idSchool
WHERE SchoolName = 'Congregation Beth Sholom Family Preschool' AND AppointmentStatus = 'pending';

#Bright Horizons at Garner is going to hold an info session on March 23 16:00 at Room 101. 
#before
SELECT idEvent, School.idSchool, SchoolName, EventName, EventDate FROM Event JOIN School ON Event.idSchool = School.idSchool
WHERE SchoolName = 'Bright Horizons at Garner'; 

#insert
INSERT INTO Event (idSchool, EventName, EventCapacity, EventDate, EventPerson, Location)
VALUES (9, 'Info Session', 30, '2018/03/23 16:00'  , 'Raj Das', 'Rm 101');

#after
SELECT idEvent, School.idSchool, SchoolName, EventName, EventDate FROM Event JOIN School ON Event.idSchool = School.idSchool
WHERE SchoolName = 'Bright Horizons at Garner';  

#Bright Horizons at Garner is going to cancel the info session on March 23 16:00 at Room 101 because there are too few people attending. 
#before
SELECT idEvent, School.idSchool, SchoolName, EventName, EventDate FROM Event JOIN School ON Event.idSchool = School.idSchool
WHERE SchoolName = 'Bright Horizons at Garner';  
#delete
DELETE FROM EVENT WHERE idEvent = 20;

#after
SELECT idEvent, School.idSchool, SchoolName, EventName, EventDate FROM Event JOIN School ON Event.idSchool = School.idSchool
WHERE SchoolName = 'Bright Horizons at Garner';  
    
#Search preschools name and school district based on zip code 94502 and teaching philosophy Montessori
SELECT SchoolName, DistrictName FROM School JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE Zip = 94502;

#User ID 1 Schedules for  tours of School ID 1 (insert one row in appointment table)
#before
SELECT Appointment.* FROM Appointment JOIN School ON Appointment.idSchool = School.idSchool
WHERE SchoolName = 'Sarafi Kid'; 

#insert
INSERT INTO Appointment(idAppointment,idSchool,idUser,AppointmentTime, AppointmentStatus)
VALUES (95,1,7727751,'2017-03-21 12:00','pending');

#after
SELECT Appointment.* FROM Appointment JOIN School ON Appointment.idSchool = School.idSchool
WHERE SchoolName = 'Sarafi Kid'; 

#Update children(ID =25) profile: potty trained: no  -> yes
#before 
SELECT * FROM Child Where idChild = 25;

#update
UPDATE Child SET PottyTrained = 'Yes'
WHERE idChild = 25;

#after
SELECT * FROM Child Where idChild = 25;

#Review and rate for preschool. For example, a user wants to review Tiny Treasures Preschool. 
#before
SELECT Review.* FROM Review JOIN School ON Review.idSchool = School.idSchool
WHERE SchoolName = 'Tiny Treasures Preschool';

#Insert a rating
INSERT INTO Review (idReview, idUser, Rating, idSchool)
VALUES (201,6646860 , 5, 13);
#after
SELECT Review.* FROM Review JOIN School ON Review.idSchool = School.idSchool
WHERE SchoolName = 'Tiny Treasures Preschool';

#Maintain school information in Santa Clara School District
#Step 1: Check if all school information in Santa Clara School District are correct
SELECT School.* FROM School JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE DistrictName = 'Santa Clara';

-- Step 2: Correct wrong school information by updating the record
UPDATE School SET TSratio = '20:1'
WHERE idSchool = 20;

-- Step 3: View updated information
SELECT School.* FROM School JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE DistrictName = 'Santa Clara';

#Check total events held for all preschools in San Mateo School District 
SELECT SchoolName, COUNT(Event.idSchool) AS 'Number of Events'
FROM Event JOIN School ON Event.idSchool = School.idSchool 
JOIN SchoolDistrict ON School.idDistrict = SchoolDistrict.idDistrict
WHERE SchoolDistrict.DistrictName = 'San Mateo'
GROUP BY SchoolName;

#Metrics: 
#San Mateo School District tracks average rating score for all preschools in the District 
SELECT SchoolName,AveRatingScore FROM School JOIN SchoolDistrict ON SchoolDistrict.idDistrict = School.idDistrict 
WHERE SchoolDistrict.DistrictName = 'San Mateo';

#San Mateo School District gets an idea of how many applications all preschools received 
SELECT SchoolName, COUNT(Application.idApplication) AS 'Number of Applications' FROM Application 
JOIN School ON Application.idSchool = School.idSchool
JOIN SchoolDistrict ON SchoolDistrict.idDistrict = School.idDistrict
WHERE SchoolDistrict.DistrictName = 'San Mateo'
GROUP BY SchoolName;


#Preschool(id=1) can track how many appointments there are by month
SELECT CONCAT(YEAR(AppointmentTime), '/ ',  MONTH(AppointmentTime))AS 'Month', 
COUNT(Appointment.idAppointment) 'Number of Applications'
FROM Appointment JOIN School ON Appointment.idSchool = School.idSchool
WHERE School.SchoolName = 'Sarafi Kid'
GROUP BY 1;

#Parents track monthly tuition and rating of all preschools in one school district 
SELECT SchoolName, Tuition, AveRatingScore FROM School 
JOIN SchoolDistrict ON SchoolDistrict.idDistrict = School.idDistrict
WHERE DistrictName = 'San Franscisco';

#Index
create index schoolID on school (idSchool); 
create index districtID on SchoolDistrict (idDistrict); 
create index reviewID on Review (idReview);


#Trigger for updating average school rating
CREATE TRIGGER computeAvgRating
AFTER INSERT ON Review
FOR EACH ROW
    UPDATE School
    SET AveRatingScore = (SELECT AVG(Rating) FROM Review
                         WHERE School.idSchool = Review.idSchool)
    WHERE idSchool = NEW.idSchool;

#Create View SchoolnDistrict
CREATE VIEW SchoolnDistrict AS 
SELECT S.SchoolName, D.DistrictName,S.TSratio,S.Philosophy, S.Tuition, S.AveRatingScore
FROM School S JOIN SchoolDistrict D ON S.idDistrict=D.idDistrict;