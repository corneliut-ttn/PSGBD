SET serveroutput ON output;

DROP TABLE primes
/
CREATE TABLE primes
    (ID NUMBER(4) PRIMARY KEY NOT NULL  ,
     VALOARE INTEGER NOT NULL
    )
/


DECLARE 
   V_nr_ordine NUMBER(4) :=1;
   V_high_limit NUMBER(4) :=2000 ;
   V_n INTEGER :=2;
BEGIN

  INSERT INTO primes(ID,VALOARE)
  VALUES(V_nr_ordine,V_n);
  V_nr_ordine:=V_nr_ordine+1;
  
  WHILE V_n < V_high_limit LOOP
   IF MOD(V_n,2)!=0 THEN
   DECLARE 
    V_nr_divizori INTEGER:=0;
    V_n_limit INTEGER:= CEIL(V_n/2);
    BEGIN
      FOR i IN 2..V_n_limit LOOP
        IF MOD(V_n,i)=0 THEN
          V_nr_divizori:=V_nr_divizori+1;
        END IF;
      END LOOP;
      IF V_nr_divizori=0 THEN
        INSERT INTO primes(ID,VALOARE)
        VALUES(V_nr_ordine,V_n);
        V_nr_ordine:=V_nr_ordine+1;
      END IF;
    END;
   END IF;
   V_n:=V_n+1;
  END LOOP;
  
  DELETE FROM primes
  WHERE valoare<1800 AND valoare >1500;
  
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT ||' randuri sterse.');

END;
