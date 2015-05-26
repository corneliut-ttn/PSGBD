SET serveroutput ON output;

CREATE OR REPLACE PACKAGE hw9_dynamicSQL_2 IS
  PROCEDURE create_job_tables;
  PROCEDURE populate_job_tables;
  PROCEDURE delete_job_table(v_table_name IN VARCHAR);
  PROCEDURE drop_all;
END hw9_dynamicSQL_2;
/


CREATE OR REPLACE PACKAGE BODY hw9_dynamicSQL_2 IS
  PROCEDURE create_job_tables IS
    v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
    v_CreateTableString  VARCHAR2(500); -- SQL stored as string to create a table
    v_NUMRows  INTEGER; -- Number of rows processed - of no use
  
    CURSOR job_cursor IS
    SELECT DISTINCT(job)
    FROM emp;
    
    job_rec job_cursor%ROWTYPE;
    v_tableName VARCHAR(25);
  BEGIN
    FOR job_rec IN job_cursor LOOP
      BEGIN
      v_tableName:= 'EMP_'||job_rec.job;
      v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
      v_CreateTableString := 'CREATE TABLE '||RTRIM(v_tableName)||'(
            EMPNO NUMBER(4) NOT NULL, 
            ENAME CHAR(10) NULL, 
            JOB CHAR(9) NULL, 
            MGR NUMBER(4) NULL, 
            HIREDATE DATE NULL , 
            SAL NUMBER(7,2) NULL, 
            COMM NUMBER(7,2) NULL, 
            DEPTNO NUMBER(2))'; -- Write SQL code to create table
 
      DBMS_SQL.PARSE(v_CursorID,v_CreateTableString,DBMS_SQL.V7); /* Perform syntax error checking */
      v_NumRows := DBMS_SQL.EXECUTE(v_CursorID);    /* Execute the SQL code  */
    
      
      EXCEPTION
      WHEN OTHERS THEN
           IF SQLCODE != -955 THEN -- 955 is error that table exists
                RAISE; -- raise if some other unknown error
           ELSE
                DBMS_OUTPUT.PUT_LINE('Table Already Exists!');
           END IF;
      DBMS_SQL.CLOSE_CURSOR(v_CursorID); -- Close the cursor
      END;
    END LOOP;
  END;
  
   PROCEDURE populate_job_tables IS
     v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
     v_InsertRecords  VARCHAR2(500); -- SQL stored as string to insert
     v_NumRows  INTEGER; -- Number of rows processed - of no use
     
     CURSOR emp_cursor IS
       SELECT *
       FROM emp;
    
    emp_rec emp_cursor%ROWTYPE;
    v_tableName VARCHAR(25);
   BEGIN
      
    FOR emp_rec IN emp_cursor LOOP
      v_tableName:= 'EMP_'||emp_rec.job;
      v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
      v_InsertRecords := 'INSERT INTO '||v_tableName||'(empno,ename,job,mgr,hiredate,sal,comm,deptno)
           VALUES (:v_empno,:v_ename,:v_job,:v_mgr,:v_hiredate,:v_sal,:v_comm,:v_deptno)'; -- Write SQL to insert records
      DBMS_SQL.PARSE(v_CursorID,v_InsertRecords,DBMS_SQL.V7); /* Perform syntax error checking */
      
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_empno',emp_rec.empno);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_ename',emp_rec.ename);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_job',emp_rec.job);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_mgr',emp_rec.mgr);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_hiredate',emp_rec.hiredate);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_sal',emp_rec.sal);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_comm',emp_rec.comm);
      DBMS_SQL.BIND_VARIABLE(v_CursorID, ':v_deptno',emp_rec.deptno);
      
      v_NumRows := DBMS_SQL.EXECUTE(v_CursorID); /* Execute the SQL code  */    
    END LOOP;
   END;
   
    PROCEDURE delete_job_table(v_table_name IN VARCHAR)IS
     v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
     v_DeleteTableString VARCHAR2(500); -- SQL stored as string to insert
     v_NumRows  INTEGER; -- Number of rows processed - of no use
    BEGIN
      v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
      v_DeleteTableString := 'DROP TABLE '||RTRIM(v_table_name); -- Write SQL code to create table
 
      DBMS_SQL.PARSE(v_CursorID,v_DeleteTableString,DBMS_SQL.V7); /* Perform syntax error checking */
      v_NumRows := DBMS_SQL.EXECUTE(v_CursorID);    /* Execute the SQL code  */
    END;
    
    PROCEDURE drop_all IS
      v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
      v_DropTableString  VARCHAR2(500); -- SQL stored as string to create a table
      v_NumRows  INTEGER; -- Number of rows processed - of no use
  
      CURSOR job_cursor IS
      SELECT DISTINCT(job)
      FROM emp;
      
      job_rec job_cursor%ROWTYPE;
      v_tableName VARCHAR(25);
    BEGIN
       FOR job_rec IN job_cursor LOOP
        v_tableName:= 'EMP_'||job_rec.job;
        v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
        v_DropTableString := 'DROP TABLE '||RTRIM(v_tableName); -- Write SQL code to create table
   
        DBMS_SQL.PARSE(v_CursorID,v_DropTableString,DBMS_SQL.V7); /* Perform syntax error checking */
        v_NumRows := DBMS_SQL.EXECUTE(v_CursorID);    /* Execute the SQL code  */
      END LOOP;
    END;
END hw9_dynamicSQL_2;
/

BEGIN
    hw9_dynamicSQL_2.drop_all;
    hw9_dynamicSQL_2.create_job_tables;
    hw9_dynamicSQL_2.populate_job_tables;
    hw9_dynamicSQL_2.delete_job_table('emp_salesman');
END;
/
  select * from emp_manager;
  select * from emp_salesman;