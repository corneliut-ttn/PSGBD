  SET serveroutput ON output;
  
DROP TABLE FiboPrime
/
CREATE TABLE FiboPrime
    (VALUE NUMBER(4) PRIMARY KEY NOT NULL  ,
     PRIME NUMBER(1) NOT NULL
    )
/


  BEGIN
  
   MERGE INTO FiboPrime 
    USING fibonacci 
    ON ( fibonacci.VALOARE < 0 )
   WHEN MATCHED THEN
    UPDATE SET
    FIBOPRIME.PRIME = null
   WHEN NOT MATCHED THEN
    INSERT VALUES(fibonacci.VALOARE,'0');
   
  MERGE INTO FiboPrime
   USING primes
   ON (FiboPrime.VALUE = primes.VALOARE)
  WHEN MATCHED THEN
   UPDATE SET
   FiboPrime.PRIME = 1;
   
  END;
  