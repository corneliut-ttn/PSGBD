 SET serveroutput ON output;
 
  DROP TABLE forest;
  CREATE TABLE forest (ID NUMBER PRIMARY KEY, X NUMBER(4) NOT NULL, Y NUMBER(4) NOT NULL, TYPE VARCHAR2(5));
  
CREATE OR REPLACE PROCEDURE create_forest (no_of_trees IN NUMBER,  
        no_of_maple OUT NUMBER, no_of_alder OUT NUMBER, no_of_birch OUT NUMBER,no_of_beech OUT NUMBER, no_of_oak OUT NUMBER ) IS
  V_counter NUMBER;
  V_rx NUMBER(4):=0;
  V_ry NUMBER(4):=0;
  V_rtype NUMBER(1):=0;
  V_random_type VARCHAR2(5);
  
BEGIN
  no_of_maple:=0;
  no_of_alder:=0;
  no_of_birch:=0;
  no_of_beech:=0;
  no_of_oak:=0;
  FOR V_counter IN 1..no_of_trees LOOP
  
    V_rx:=TRUNC(dbms_random.value(0,1000));
    V_ry:=TRUNC(dbms_random.value(0,1000));
    V_rtype:=TRUNC(dbms_random.value(1,6));
    
    CASE V_rtype
    WHEN 1 THEN V_random_type:='maple';no_of_maple:=no_of_maple+1;
    WHEN 2 THEN V_random_type:='alder';no_of_alder:=no_of_alder+1;
    WHEN 3 THEN V_random_type:='birch';no_of_birch:=no_of_birch+1;
    WHEN 4 THEN V_random_type:='beech';no_of_beech:=no_of_beech+1;
    ELSE  V_random_type:='oak';no_of_oak:=no_of_oak+1;
    END CASE;
    
    INSERT INTO forest (ID,X,Y,TYPE) VALUES (V_counter,V_rx,V_ry,V_random_type);
    
  END LOOP;
  
END create_forest; 
/

  DECLARE 
  no_of_maple NUMBER;
  no_of_alder NUMBER;
  no_of_birch NUMBER;
  no_of_beech NUMBER;
  no_of_oak   NUMBER;
  
  BEGIN
  create_forest(1000000,no_of_maple,no_of_alder,no_of_birch,no_of_beech,no_of_oak);
  DBMS_OUTPUT.PUT_LINE('Inserted '||no_of_maple ||' maple trees');
  DBMS_OUTPUT.PUT_LINE('Inserted '||no_of_alder ||' alder trees');
  DBMS_OUTPUT.PUT_LINE('Inserted '||no_of_birch ||' birch trees');
  DBMS_OUTPUT.PUT_LINE('Inserted '||no_of_beech ||' beech trees');
  DBMS_OUTPUT.PUT_LINE('Inserted '||no_of_oak ||' oak trees');
  END;
  
  DROP TABLE locations;
  CREATE TABLE locations (ID NUMBER PRIMARY KEY, X NUMBER(4) NOT NULL, Y NUMBER(4) NOT NULL);
  
  
  CREATE OR REPLACE PROCEDURE set_locations (no_of_locations IN NUMBER) IS
  V_counter NUMBER;
  V_rx NUMBER(4):=0;
  V_ry NUMBER(4):=0;
  
  BEGIN
 
  FOR V_counter IN 1..no_of_locations LOOP
  
    V_rx:=TRUNC(dbms_random.value(0,1000));
    V_ry:=TRUNC(dbms_random.value(0,1000));
    
    INSERT INTO locations (ID,X,Y) VALUES (V_counter,V_rx,V_ry);
    
  END LOOP;
  
END set_locations; 
/

BEGIN
 set_locations(100);
END;

 CREATE OR REPLACE FUNCTION calculateNoTrees (coord_X IN NUMBER,coord_Y IN NUMBER) RETURN NUMBER IS
  
  v_tree_number NUMBER:=0;
  BEGIN
  SELECT COUNT(id) INTO v_tree_number
   FROM (SELECT * 
          FROM forest
          WHERE X BETWEEN (coord_X-25) AND (coord_X+25) AND Y BETWEEN (coord_Y-25) AND (coord_Y+25) )
   WHERE POWER((X - coord_X),2)+POWER((Y - coord_Y),2)<=625;

  RETURN v_tree_number;
 END calculateNoTrees; 
 /
 
 DECLARE
  v_no NUMBER:=0;
 BEGIN
  v_no:=calculateNoTrees(500,500);
  DBMS_OUTPUT.PUT_LINE('There are '||v_no ||' trees around those coordinates that have to be cut down');
 END;
 
 DROP INDEX forest_index;
 CREATE INDEX forest_index ON forest(X,Y);
 
 SELECT MIN(calculateNoTrees(X,Y))
 FROM locations;

