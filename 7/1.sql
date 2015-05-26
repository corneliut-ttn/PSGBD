@http://profs.info.uaic.ro/~vcosmin/pagini/resurse_psgbd/Script/Script.sql

 SET serveroutput ON output;
 
--type creation of objects with empno and procent as fields
CREATE OR REPLACE TYPE sal_raise_type AS OBJECT (
empno NUMBER(5),
procent NUMBER(5,3)
);
/

--type creation for object raise with the new salary and date as fields
CREATE OR REPLACE TYPE raised_sal_type AS OBJECT (
new_salary NUMBER(7,2),
modified_date DATE 
);
/

CREATE OR REPLACE TYPE raised_sal_table_type 
AS TABLE OF raised_sal_type;
/

ALTER TABLE emp 
ADD (modified_sal raised_sal_table_type) 
NESTED TABLE modified_sal 
STORE AS nested_modified_sal_table;
/

UPDATE emp 
SET  modified_sal = raised_sal_table_type(raised_sal_type(sal,hiredate)); -- add initial values
/

CREATE OR REPLACE PACKAGE collection_hw7 IS
  
  --declaration of nasted table
   TYPE sal_raise_table_type IS TABLE OF sal_raise_type;
 
  --function with nasted table as parameter
  PROCEDURE increase_salaries (employees IN sal_raise_table_type);
  
  --fuction that shows the history of modified salaries
  PROCEDURE  show_salary_history;
  
END collection_hw7;
/

CREATE OR REPLACE PACKAGE BODY collection_hw7 IS
  
  PROCEDURE increase_salaries (employees IN sal_raise_table_type) IS
      v_new_salary emp.sal%TYPE;
      v_empno emp.empno%TYPE;
    BEGIN
      FOR it IN employees.FIRST .. employees.LAST
        LOOP
          
          BEGIN
          
            SELECT empno INTO v_empno
            FROM emp 
            WHERE emp.empno=employees(it).empno;
            
            UPDATE emp 
              SET 
                emp.sal =emp.sal + emp.sal * employees(it).procent
              WHERE 
                emp.empno=v_empno;
                
            SELECT sal INTO v_new_salary 
            FROM emp 
            WHERE emp.empno =v_empno ;
            
            INSERT INTO TABLE (SELECT modified_sal 
                               FROM emp 
                                WHERE empno = v_empno ) VALUES ( v_new_salary ,SYSDATE);
          
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
              DBMS_OUTPUT.PUT_LINE('employee ' || employees(it).empno || ' does not exist');
          END;
      END LOOP;
    END increase_salaries;
    
    PROCEDURE  show_salary_history IS
    
      CURSOR emp_cursor
      IS SELECT empno,ename
      FROM emp;
      
      emp_rec emp_cursor%ROWTYPE;
      
      history emp.modified_sal%TYPE;
      history_no NUMBER;
    BEGIN
      FOR emp_rec IN emp_cursor LOOP
        SELECT COUNT(*) INTO history_no 
        FROM TABLE (SELECT modified_sal 
                    FROM emp WHERE emp.empno=emp_rec.empno);
        IF history_no > 1
        THEN 
          SELECT modified_sal INTO history
          FROM emp 
          WHERE empno=emp_rec.empno;
          DBMS_OUTPUT.PUT_LINE('Emp : '||emp_rec.ename);
          FOR it IN history.FIRST .. history.LAST
            LOOP
                DBMS_OUTPUT.PUT_LINE(history(it).new_salary || ' at ' || history(it).modified_date);
            END LOOP;
        END IF;
      END LOOP;
    
    END show_salary_history;
  
END collection_hw7; 
/

DECLARE
  V_emp_1 sal_raise_type;
  V_emp_2 sal_raise_type;
  V_emp_3 sal_raise_type;
  V_emp_4 sal_raise_type;
  V_nest_table collection_hw7.sal_raise_table_type;
  
BEGIN
  
  V_emp_1 := sal_raise_type(7499,0.1);
  V_emp_2 := sal_raise_type(7788,1.2);
  V_emp_3 := sal_raise_type(1234,0.54);
  V_emp_4 := sal_raise_type(7499,0.05);
  
  V_nest_table := collection_hw7.sal_raise_table_type(V_emp_1,V_emp_2,V_emp_3,V_emp_4);
  
  collection_hw7.increase_salaries(V_nest_table);
  
  collection_hw7.show_salary_history;
END;
/

SELECT * 
FROM emp;

rollback;
COMMIT;




