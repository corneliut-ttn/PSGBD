  SET serveroutput ON output;

DROP TABLE src;
CREATE TABLE src(
	empno NUMBER(4) NOT NULL,
	ename CHAR(10),
	job   CHAR(9),
	mgr	  NUMBER(4),	
	copied NUMBER(1)
);
INSERT INTO  src VALUES(9001,'NIKON','ANALYST',7902,null);
INSERT INTO  src VALUES(9002,'FORD','ANALYST',7902,null);
INSERT INTO  src VALUES(9003,'CANON','ANALYST',7902,null);
INSERT INTO  src VALUES(9004,'CANON','ANALYST',7902,null);

DROP INDEX src_index;

CREATE INDEX src_index on src(ename);

COMMIT;

DECLARE
  CURSOR src_cursor 
	IS
	SELECT empno,ename,job,mgr
	FROM src
  FOR UPDATE OF copied ;
  
  src_rec src_cursor%ROWTYPE;
  ok_emp NUMBER(1):=0;
  name CHAR(10);
BEGIN

  FOR src_rec IN src_cursor LOOP
    
    SELECT COUNT(emp.ename) INTO ok_emp
    FROM emp
    WHERE src_rec.ename=emp.ename;
   
    
    IF(ok_emp<1)
    THEN
    INSERT INTO EMP VALUES(src_rec.empno,src_rec.ename,src_rec.job,src_rec.mgr,NULL,NULL,NULL,NULL);
    	dbms_output.put_line('The employee has been inserted successfully ');	
     UPDATE SRC
					SET copied = 1
					--WHERE src_rec.empno = empno;
          WHERE CURRENT OF src_cursor;
    ELSE 
     UPDATE SRC
					SET copied = 0
					--WHERE src_rec.empno = empno;
           WHERE CURRENT OF src_cursor;
      RAISE TOO_MANY_ROWS;
    END IF;
    
  END LOOP;

	EXCEPTION WHEN TOO_MANY_ROWS THEN
		dbms_output.put_line('The employee has been inserted previously ');	

END;
/

SELECT ename AS "Angajati copiati cu succes:"
FROM src 
WHERE copied=1;


SELECT ename AS "Nu au putut fi copiati:"
FROM src 
WHERE copied=0;