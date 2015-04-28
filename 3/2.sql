  SET serveroutput ON output;
  
DECLARE

  CURSOR dept_location (p_dept_no NUMBER) IS
    SELECT loc,((emp.sal)/(SYSDATE-emp.hiredate))valoare,ename
    FROM dept,emp
    WHERE emp.deptno=p_dept_no;
  
  v_dept_location_record dept_location%ROWTYPE;
  v_max NUMBER:=-1;
  v_ename emp.ename%TYPE;
  v_loc dept.loc%TYPE;
BEGIN
  OPEN dept_location( 20 );
    LOOP
      FETCH dept_location into v_dept_location_record;
      EXIT WHEN dept_location%NOTFOUND;
      IF v_max < v_dept_location_record.valoare THEN 
        v_max:=v_dept_location_record.valoare;
        v_ename:=v_dept_location_record.ename;
        v_loc:=v_dept_location_record.loc;
      END IF;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('Valoarea angajatului '||RTRIM(v_ename)||' = '||v_max||' ; lucreaza in  '|| v_loc );
     
  CLOSE dept_location; 
  
END;