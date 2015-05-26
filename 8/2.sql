CREATE OR REPLACE TYPE employee AS OBJECT (
empno NUMBER(5),
ename VARCHAR(20),
dept REF departament,
sal NUMBER(7,2),
ORDER MEMBER FUNCTION orderManager (e employee) RETURN INTEGER
)NOT FINAL;
/