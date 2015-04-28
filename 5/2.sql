 SET serveroutput ON output;
 
 DROP PROCEDURE INCREASE_SAL;
CREATE OR REPLACE PROCEDURE INCREASE_SAL (value_to_increase IN NUMBER)
AS
	CURSOR emp_cursor IS
	SELECT empno,sal
  FROM EMP
  WHERE job='MANAGER' ;
	emp_rec emp_cursor%rowtype;
BEGIN
	FOR emp_rec in emp_cursor LOOP
		UPDATE  emp
			SET 
				emp.sal = emp.sal+value_to_increase
      WHERE 
        emp_rec.empno = empno;
	END LOOP;
END INCREASE_SAL;
/

  DECLARE
    sal_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(sal_exception, -60);
    CURSOR emp_cursor IS
    SELECT empno,ename,job,sal 
    FROM EMP
    WHERE job='MANAGER';
    emp_rec emp_cursor%rowtype;
    diff NUMBER(5);
  BEGIN
    INCREASE_SAL(500);
    FOR emp_rec in emp_cursor LOOP
      BEGIN
      IF(emp_rec.sal<3000)
      THEN
        dbms_output.put_line(emp_rec.ename || ' ' || 'Salary: ' ||emp_rec.sal|| ' increased with 500');
      ELSE
       RAISE sal_exception;
      END IF;	
 
    EXCEPTION WHEN sal_exception THEN
      diff:=500-(emp_rec.sal-3000);
       UPDATE  emp
        SET 
          emp.sal = 3000
        WHERE 
          emp_rec.empno = empno;
      dbms_output.put_line(emp_rec.ename || ' ' || 'Salary: 3000' || ' increased with '||diff);
          END;
         END LOOP;
      
     
  END;
  /
  
  rollback;

