CREATE OR REPLACE TYPE manager UNDER employee (
nrEmp NUMBER(4),
CONSTRUCTOR FUNCTION Manager RETURN SELF AS RESULT,
MEMBER FUNCTION orderManager (mgrCompare manager) RETURN INTEGER
);
/
CREATE OR REPLACE TYPE BODY manager AS 

MEMBER FUNCTION orderManager (mgrCompare manager) RETURN INTEGER IS
  BEGIN
    IF mgrCompare.nrEmp>nrEmp THEN RETURN (-1);
    ELSIF mgrCompare.nrEmp=nrEmp THEN RETURN 0;
    ELSIF mgrCompare.nrEmp<nrEmp THEN RETURN 1;
    END IF;
  END;

  CONSTRUCTOR FUNCTION manager RETURN SELF AS RESULT AS
    BEGIN
      RETURN;
    END;
END;
/