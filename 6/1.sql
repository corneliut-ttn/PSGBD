
GRANT EXECUTE ON UTL_FILE TO SYS;
 
CREATE OR REPALCE DIRECTORY TEMP_DIR AS 'D:\UAIC-COMPUTERSCIENCE';

GRANT READ, WRITE ON DIRECTORY TEMP_DIR TO SYS;

 --SET serveroutput ON output;

  CREATE OR REPLACE PACKAGE emp_management IS
  
  PROCEDURE add_emp (v_name IN emp.ename%TYPE,
                     v_sal IN emp.sal%TYPE,
                     v_job IN emp.job%TYPE,
                     v_mgr IN emp.mgr%TYPE);
  PROCEDURE fire_emp(v_name IN emp.ename%TYPE);
  PROCEDURE fire_emp(v_id IN emp.empno%TYPE);
  PROCEDURE add_dept(v_name IN dept.dname%TYPE,
                      v_loc IN dept.loc%TYPE);
  PROCEDURE show(show_type IN VARCHAR);
  END emp_management;
  /
  
  CREATE OR REPLACE PACKAGE BODY emp_management IS
  --forward declarations
  PROCEDURE get_emp_id(v_id OUT emp.empno%TYPE);
  PROCEDURE get_deptno(v_deptno OUT emp.deptno%TYPE);
  PROCEDURE get_deptno(v_deptno OUT emp.deptno%TYPE,v_job IN emp.job%TYPE);
  PROCEDURE chk_dept(v_dept IN emp.deptno%TYPE);
  FUNCTION  chk_emp(v_id IN emp.empno%TYPE)RETURN BOOLEAN;
  FUNCTION  chk_emp(v_name IN emp.ename%TYPE)RETURN BOOLEAN;
  FUNCTION  chk_job(v_job IN emp.job%TYPE)RETURN BOOLEAN;
  FUNCTION  chk_mgr(v_id IN emp.mgr%TYPE)RETURN BOOLEAN;
  
  PROCEDURE add_dept(v_name IN dept.dname%TYPE,
                      v_loc IN dept.loc%TYPE)
  IS
    v_deptno dept.deptno%TYPE;
  BEGIN
    SELECT MAX(deptno)+10 INTO v_deptno
    FROM dept;
     INSERT INTO dept(deptno,dname,loc) VALUES(v_deptno,v_name,v_loc);
  END add_dept;
  
  PROCEDURE add_emp (v_name IN emp.ename%TYPE,
                     v_sal IN emp.sal%TYPE,
                     v_job IN emp.job%TYPE,
                     v_mgr IN emp.mgr%TYPE)
   IS
    v_id emp.empno%TYPE:=0;
    v_deptno emp.deptno%TYPE:=0;
    p_res BOOLEAN:=TRUE;
  BEGIN
    get_emp_id(v_id);
    p_res:=chk_mgr(v_mgr);
    if (chk_job(v_job)=TRUE)
      then get_deptno(v_deptno,v_job);
      else get_deptno(v_deptno);
    end if;
    
   INSERT INTO emp(empno,ename,job,mgr,sal,deptno) VALUES(v_id,v_name,v_job,v_mgr,v_sal,v_deptno);
    
  END add_emp;
  
  PROCEDURE chk_dept(v_dept emp.deptno%TYPE)
  IS
  v_count NUMBER:=0;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM emp
    WHERE emp.deptno=v_dept;
    
    IF(v_count=0)THEN
      DELETE FROM dept
      WHERE dept.deptno=v_dept;
    END IF;
  END chk_dept;
  
  FUNCTION chk_emp(v_name emp.ename%TYPE)
    RETURN BOOLEAN IS
    p_res emp.ename%TYPE;
  BEGIN
  SELECT ename INTO p_res
    FROM emp 
    WHERE ename=v_name;
    IF (p_res is not null)THEN RETURN TRUE;
    ELSE 
    RAISE_APPLICATION_ERROR(-20200, 'Invalid employee');
    RETURN FALSE;
    END IF;
  END chk_emp;
  
  FUNCTION chk_emp(v_id emp.empno%TYPE)
    RETURN BOOLEAN IS
    p_res emp.ename%TYPE;
  BEGIN
  SELECT ename INTO p_res
    FROM emp 
    WHERE empno=v_id;
    IF (p_res is not null)THEN RETURN TRUE;
    ELSE 
    RAISE_APPLICATION_ERROR(-20200, 'Invalid employee');
    RETURN FALSE;
    END IF;
  END chk_emp;
  
  FUNCTION chk_mgr(v_id emp.mgr%TYPE)
    RETURN BOOLEAN IS
    p_res emp.ename%TYPE;
  BEGIN
  SELECT ename INTO p_res
    FROM emp 
    WHERE empno=v_id;
    IF (p_res is not null)THEN RETURN TRUE;
    ELSE 
    RAISE_APPLICATION_ERROR(-20200, 'Invalid manager');
    RETURN FALSE;
    END IF;
  END chk_mgr;
  
  FUNCTION chk_job(v_job emp.job%TYPE)
    RETURN BOOLEAN IS

    CURSOR job_cursor IS
      SELECT job
     FROM emp;
  
     job_rec job_cursor%ROWTYPE;

    BEGIN

    FOR job_rec in job_cursor LOOP
  
     IF (v_job=job_rec.job)
       THEN RETURN TRUE;
      END IF;
    END LOOP;
    RETURN FALSE;
  END chk_job;
  
   PROCEDURE fire_emp(v_name IN emp.ename%TYPE)AS
    v_dept emp.deptno%TYPE;
    p_res BOOLEAN:=TRUE;
   BEGIN
    p_res:=chk_emp(v_name);
    IF(p_res=TRUE)THEN
      DELETE FROM emp
      WHERE emp.ename=v_name;
      SELECT deptno INTO v_dept
     FROM emp
     WHERE emp.ename=v_name;
      END IF;
   
   END fire_emp;
   
  PROCEDURE fire_emp(v_id IN emp.empno%TYPE)AS
   v_dept emp.deptno%TYPE;
  p_res BOOLEAN:=TRUE;
  BEGIN
  p_res:=chk_emp(v_id);
  IF(p_res=TRUE)THEN
     DELETE FROM emp
      WHERE emp.empno=v_id;
     SELECT deptno INTO v_dept
     FROM emp
     WHERE emp.empno=v_id;
    END IF;
    
  END fire_emp;
  
  
  PROCEDURE get_deptno(v_deptno OUT emp.deptno%TYPE) AS
  
    CURSOR dept_cursor 
    IS
    SELECT deptno
    FROM dept;
    
    dept_rec dept_cursor%ROWTYPE;
    p_min NUMBER:=1000;
    p_count NUMBER:=0;
  BEGIN
    FOR emp_rec in dept_cursor LOOP
  
    SELECT COUNT(empno) INTO p_count
      FROM emp
      WHERE emp.deptno=emp_rec.deptno;
  
    IF p_count<p_min THEN
     p_min:=p_count;
    v_deptno:=emp_rec.deptno;
  END IF;
  
   END LOOP;
  END;
  
  PROCEDURE get_deptno(v_deptno OUT emp.deptno%TYPE,v_job IN emp.job%TYPE) AS
  
    CURSOR dept_cursor 
    IS
    SELECT deptno
    FROM dept;
  
    dept_rec dept_cursor%ROWTYPE;
    p_min NUMBER:=1000;
    p_count NUMBER:=0;
  BEGIN
    FOR emp_rec in dept_cursor LOOP
  
    SELECT COUNT(empno) INTO p_count
      FROM emp
      WHERE emp.deptno=emp_rec.deptno AND emp.job=v_job;
  
    IF p_count<p_min THEN
     p_min:=p_count;
    v_deptno:=emp_rec.deptno;
  END IF;
  
   END LOOP;
  END;
  
  PROCEDURE get_emp_id(v_id OUT emp.empno%TYPE) IS
  BEGIN
    SELECT MAX(empno)INTO v_id
    FROM emp;
    v_id:=v_id+1;
  END get_emp_id;
  
  PROCEDURE show(show_type IN VARCHAR )IS
  fileOut UTL_FILE.FILE_TYPE;
   CURSOR emp_cursor 
    IS
    SELECT *
    FROM emp;
    emp_rec emp_cursor%ROWTYPE;
  BEGIN
    IF (show_type='ecran')
      THEN 
        FOR emp_rec IN emp_cursor LOOP
         DBMS_OUTPUT.PUT_LINE(emp_rec.empno||' '||emp_rec.ename||' '||emp_rec.job||' '||emp_rec.mgr||' '||emp_rec.hiredate||' '||emp_rec.sal||' '||emp_rec.comm||' '||emp_rec.deptno );
        END LOOP;
      END IF;
      IF (show_type='fisier')
        THEN
         fileOut := UTL_FILE.FOPEN('TEMP_DIR', 'file_output.txt', 'W');
         FOR emp_rec IN emp_cursor LOOP
           UTL_FILE.PUT_LINE(fileOut, emp_rec.empno||' '||emp_rec.ename||' '||emp_rec.job||' '||emp_rec.mgr||' '||emp_rec.hiredate||' '||emp_rec.sal||' '||emp_rec.comm||' '||emp_rec.deptno );
          END LOOP;
         UTL_FILE.FCLOSE(fileOut);
      END IF;
    
  END show;
  
  END emp_management;
  /

GRANT EXECUTE ON emp_management TO SYS;

 DECLARE
 BEGIN
  emp_management.show('ecran');
  emp_management.add_dept('IT','IASINGTON');
  emp_management.add_emp('BOND',9000,'SPY',7839);
  emp_management.add_emp('TUTUIANU',4999,'MANAGER',7839);
  emp_management.show('ecran');
  emp_management.fire_emp('BOND');
  emp_management.fire_emp(9003);
  emp_management.show('fisier');
 END;
 
 --rollback;