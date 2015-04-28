               
SET serveroutput ON output;

DECLARE
  V_ename emp.ename%TYPE;
BEGIN
  SELECT ename 
   INTO V_ename
   FROM emp
   WHERE LENGTH(RTRIM(ename,' '))=(SELECT MAX(LENGTH(RTRIM(ename,' '))) 
                                     FROM emp) AND ROWNUM=1;
  dbms_output.put_line('(Unul dintre)Numele cel mai lung este: '||INITCAP(V_ename));    
  dbms_output.put_line('Are lungimea de :'||LENGTH(RTRIM(V_ename,' '))||' caractere');    
END;