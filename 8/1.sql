SET serveroutput ON output;
DROP TYPE manager FORCE;
DROP TYPE employee FORCE;
DROP TYPE departament FORCE;


CREATE OR REPLACE TYPE departament AS OBJECT (
deptno NUMBER(5),
dname VARCHAR(20)
);
/