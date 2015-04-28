  SET serveroutput ON output;
  
  DROP TABLE fibonacci;
  /
  CREATE TABLE fibonacci
      (ID NUMBER(4) PRIMARY KEY NOT NULL  ,
       VALOARE INTEGER NOT NULL
      );
  /
  
  DECLARE 
    V_high_limit NUMBER(4) :=1000;
    V_n INTEGER :=0;
    V_n_minus_1 INTEGER :=1;
    V_n_minus_2 INTEGER :=0;
    V_nr_ordine NUMBER(4) :=1;
  BEGIN
   V_n:=V_n_minus_1 + V_n_minus_2;
   V_n_minus_2:=V_n_minus_1;
   V_n_minus_1:=V_n;
  
    WHILE V_n < V_high_limit LOOP
      INSERT INTO fibonacci(ID,VALOARE)
        VALUES(V_nr_ordine,V_n);
      V_nr_ordine:=V_nr_ordine+1;
      V_n:=V_n_minus_1 + V_n_minus_2;
      V_n_minus_2:=V_n_minus_1;
      V_n_minus_1:=V_n;
    END LOOP;
  
  END;
  
 
 
  