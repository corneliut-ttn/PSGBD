  SET serveroutput ON output;
  
DECLARE

  CURSOR emp_cursor IS
    SELECT ename
    FROM emp
    WHERE sal > 1500;
  
  v_empname emp.ename%TYPE;
 
BEGIN
  OPEN emp_cursor;
    LOOP
      FETCH emp_cursor INTO v_empname;
      EXIT WHEN emp_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( v_empname );
  END LOOP;
  CLOSE emp_cursor;
END;