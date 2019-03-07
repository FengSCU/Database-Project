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