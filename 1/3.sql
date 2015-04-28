<<X>>
DECLARE
  v_variable VARCHAR2(25):='first level';
BEGIN
    <<Y>>
    DECLARE
     v_variable VARCHAR2(25):='second level';
    BEGIN
      <<Z>>
      DECLARE
       v_variable VARCHAR(25):='third level';
      BEGIN
       DBMS_OUTPUT.PUT_LINE(X.v_variable);
       DBMS_OUTPUT.PUT_LINE(Y.v_variable);
       DBMS_OUTPUT.PUT_LINE(Z.v_variable);
      END;
     DBMS_OUTPUT.PUT_LINE(X.v_variable);
       DBMS_OUTPUT.PUT_LINE(Y.v_variable);
    END;
  DBMS_OUTPUT.PUT_LINE(X.v_variable);
END;