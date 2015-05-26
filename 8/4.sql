DROP TABLE departaments;
/
CREATE TABLE departaments of departament;
/

DROP TABLE managers;
/
CREATE TABLE managers ( mgr manager);
/

CREATE OR REPLACE PACKAGE homework_8 IS

   PROCEDURE populate_dept;
   PROCEDURE populate_managers;
END homework_8;
/

CREATE OR REPLACE PACKAGE BODY homework_8 IS
  
  PROCEDURE populate_dept IS
    CURSOR dept_cursor
      IS SELECT deptno,dname
      FROM dept;
    dept_rec dept_cursor%ROWTYPE;
  BEGIN
     FOR dept_rec IN dept_cursor LOOP
      INSERT INTO departaments VALUES(departament(dept_rec.deptno,dept_rec.dname));
     END LOOP;
  END;
  
  PROCEDURE populate_managers IS
     CURSOR emp_mgr_cursor
        IS SELECT empno,ename,deptno,sal
        FROM emp
        WHERE empno IN (SELECT mgr from emp);  
     emp_mgr_rec emp_mgr_cursor%ROWTYPE; 
     v_empNr NUMBER(3);
     v_mgr manager:=manager();
  BEGIN
    FOR emp_mgr_rec IN emp_mgr_cursor LOOP
    
      SELECT COUNT(*) INTO v_empNr
          FROM emp 
          WHERE mgr=emp_mgr_rec.empno;
     
     v_mgr.empno := emp_mgr_rec.empno;
     v_mgr.ename := emp_mgr_rec.ename;
     v_mgr.sal := emp_mgr_rec.sal;
     v_mgr.nrEmp := v_empNr;
     SELECT REF(dept) INTO v_mgr.dept FROM departaments dept WHERE dept.deptno=(SELECT deptno FROM emp WHERE empno= v_mgr.empno );   
     
     INSERT INTO managers values(v_mgr);
      END LOOP;
  END;
    
END homework_8;
/

  BEGIN
   homework_8.populate_dept;
   homework_8.populate_managers;
  END;
/
    
    SELECT * from departaments;
    SELECT m.mgr.ename ,m.mgr.empno,m.mgr.sal,m.mgr.dept.deptno,m.mgr.dept.dname,m.mgr.nrEmp AS employees_no FROM managers m ORDER BY mgr;
