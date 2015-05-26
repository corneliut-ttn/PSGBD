CREATE OR REPLACE VIEW ultimateView AS
SELECT * FROM all_objects
WHERE owner = (select user from dual) 
;



SELECT * FROM ultimateView 
  WHERE object_type = 'PACKAGE';