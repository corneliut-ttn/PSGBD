SET serveroutput ON output;

DROP TABLE CONTRACT_ORANGE_MARTIN;
/

CREATE OR REPLACE PACKAGE hw9_dynamicSQL_1 IS
  v_tableName VARCHAR(100);
  PROCEDURE createOrangeTable;
  PROCEDURE populateOrangeTable;
END hw9_dynamicSQL_1;
/

CREATE OR REPLACE PACKAGE BODY hw9_dynamicSQL_1 IS
    PROCEDURE createOrangeTable IS
      v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
      v_CreateTableString  VARCHAR2(500); -- SQL stored as string to create a table
      v_NUMRows  INTEGER; -- Number of rows processed - of no use
  
      v_tel_no VARCHAR(10);
      v_boss VARCHAR(25);
    BEGIN
      SELECT ename INTO v_boss
      FROM emp 
      WHERE comm=(SELECT MAX(comm) FROM emp);
      v_tableName:='CONTRACT_ORANGE_'||RTRIM(UPPER(v_boss));
      v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
      v_CreateTableString := 'CREATE TABLE '||RTRIM(v_tableName)||'(
             empno NUMBER(4,0),
             telNr VARCHAR2(10))'; -- Write SQL code to create table
 
      DBMS_SQL.PARSE(v_CursorID,v_CreateTableString,DBMS_SQL.V7); /* Perform syntax error checking */
      v_NumRows := DBMS_SQL.EXECUTE(v_CursorID);    /* Execute the SQL code  */
      
      --DBMS_OUTPUT.PUT_LINE(v_NumRows);
      EXCEPTION
      WHEN OTHERS THEN
           IF SQLCODE != -955 THEN -- 955 is error that table exists
                RAISE; -- raise if some other unknown error
           ELSE
                DBMS_OUTPUT.PUT_LINE('Table Already Exists!');
           END IF;
      DBMS_SQL.CLOSE_CURSOR(v_CursorID); -- Close the cursor
    END;
    
    PROCEDURE populateOrangeTable IS
    
     v_CursorID  NUMBER; -- Variable assigned to value from OPEN_CURSOR
     v_InsertRecords  VARCHAR2(500); -- SQL stored as string to insert
     v_NumRows  INTEGER; -- Number of rows processed - of no use
    
     CURSOR emp_cursor IS
        SELECT empno
        FROM emp
        ORDER BY sal DESC;
  
      emp_rec emp_cursor%ROWTYPE;
      it NUMBER(2):=1;
      v_telNo VARCHAR(10);
    BEGIN
    
      v_CursorID := DBMS_SQL.OPEN_CURSOR; -- Get the Cursor ID
      v_InsertRecords := 'INSERT INTO '||v_tableName||'(empno,telNr)
           VALUES (:mynum,:mytext)'; -- Write SQL to insert records
      DBMS_SQL.PARSE(v_CursorID,v_InsertRecords,DBMS_SQL.V7);
           /* Perform syntax error checking */
       FOR emp_rec IN emp_cursor LOOP
        
        IF it <10 THEN
        v_telNo:='074100000'||TO_CHAR(it);
        ELSE
         v_telNo:='07410000'||TO_CHAR(it);
        END IF;
        
        DBMS_SQL.BIND_VARIABLE(v_CursorID, ':mynum',emp_rec.empno);
        DBMS_SQL.BIND_VARIABLE(v_CursorID, ':mytext',v_telNo);
        v_NumRows := DBMS_SQL.EXECUTE(v_CursorID); /* Execute the SQL code  */
        DBMS_OUTPUT.PUT_LINE('The number of records just processed is: '|| v_NUMRows);

        it:=it+1;
       END LOOP;
       
    END;
END hw9_dynamicSQL_1;
/

BEGIN
  hw9_dynamicSQL_1.createOrangeTable;
  hw9_dynamicSQL_1.populateOrangeTable;
END;
/
SELECT * FROM CONTRACT_ORANGE_MARTIN;