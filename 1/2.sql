                 
SET serveroutput ON output;

DECLARE
  C_birth_day CONSTANT VARCHAR2(30):='01-05-1994';
  V_birth_date DATE;
  V_days_passed INTEGER;
  V_months_passed INTEGER;
  V_birth_day VARCHAR(10);
BEGIN
  V_birth_date:=TO_DATE (C_birth_day);
  V_days_passed:=(SYSDATE-V_birth_date);
  V_months_passed:= MONTHS_BETWEEN(SYSDATE,V_birth_date);
  V_birth_day:=TO_CHAR(V_birth_date,'DAY');
  dbms_output.put_line('Data nasterii: '||V_birth_date);
  dbms_output.put_line('Zile de la data nasterii: '||V_days_passed);    
  dbms_output.put_line('Luni de la data nasterii: '||V_months_passed);
  dbms_output.put_line('Ziua nasterii: '||V_birth_day);
END;