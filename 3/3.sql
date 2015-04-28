  SET serveroutput ON output;
  
DECLARE

  CURSOR getManager(p_employee NUMBER) IS
    SELECT hiredate,sal
    FROM emp
    WHERE emp.empno=p_employee
    FOR UPDATE OF sal ;
    
  CURSOR employee IS
    SELECT hiredate,sal,mgr
    FROM emp
   FOR UPDATE OF sal ;
    
  V_getManager_record getManager%ROWTYPE;
  V_employee_record employee%ROWTYPE;
  
BEGIN
  FOR V_employee_record IN employee LOOP
    FOR V_getManager_record IN getManager(V_employee_record.mgr) LOOP
      IF V_getManager_record.hiredate < V_employee_record.hiredate AND (V_getManager_record.sal + V_employee_record.sal) > 4000 THEN
        UPDATE emp
          SET sal=V_employee_record.sal+1
          WHERE CURRENT OF employee;
        UPDATE emp
          SET sal=V_getManager_record.sal+1
          WHERE CURRENT OF getManager;
      END IF;
    END LOOP;
  END LOOP;
  COMMIT;
END;