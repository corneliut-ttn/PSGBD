package com.sgbd;

import java.sql.*;


/**
 * Created by Cornelius on 26.03.2015.
 */
 class ConnectToSQL {

    private String username;
    private String password;
    private String database = "xe";
    private String URL = "jdbc:oracle:thin:@localhost:1521:";
    private Connection connection;


    public ConnectToSQL(String username, String password, String database, String URL, Connection connection) {
        this.username = username;
        this.password = password;
        this.database = database;
        this.URL = URL;
        this.connection = connection;
    }

    public ConnectToSQL(){}


    public void setConnection(String username, String password) {
        this.username = username;
        this.password = password;
        try {
            this.connection = DriverManager.getConnection(URL + database, username, password);

            if (connection != null) {
                System.out.println("You made it, take control your database now!");
            } else {
                System.out.println("Failed to make connection!");
            }
        } catch (SQLException sqle) {
            sqle.printStackTrace();
        }
    }

    public void getSal(int empno) {
        try {
            CallableStatement statement = null;
            String sql = "{?=call getEmpSal (?)}";
            statement = connection.prepareCall(sql);
            statement.setInt(2, empno);
            statement.registerOutParameter(1, Types.NUMERIC );
            statement.execute();
            int empSal = statement.getInt(1);
            System.out.println("Employee salary with empno=" +
                    empno + " is " + empSal);
            statement.close();
            statement.close();
        } catch ( SQLException e ){  System.out.println("Exception catched:Employee not found, try again!");}
        finally {
            try {
                if (connection != null)
                    connection.close();
            } catch (SQLException se) {
                se.printStackTrace();
            } finally {

            }
        }
    }
}


public class Main {
/*
 SET serveroutput ON output;
 DROP FUNCTION getEmpSal;
CREATE OR REPLACE FUNCTION getEmpSal (empno_in IN NUMBER) RETURN NUMBER
IS
  sal_out NUMBER;
BEGIN
	SELECT sal into sal_out
  FROM emp
  WHERE emp.empno=empno_in;
 RETURN sal_out;
  EXCEPTION  WHEN NO_DATA_FOUND THEN
  dbms_output.put_line('Employee not found');
  --RETURN -1;

END getEmpSal;
/

DECLARE
	sal number:=0;
BEGIN

	sal:=getEmpSal(7839);

	dbms_output.put_line('Salariul     lui  '||7839||   '  este '|| sal);

END;
/
 */
    public static void main(String[] args) {
        ConnectToSQL SQL=new ConnectToSQL();
        SQL.setConnection("CORNELIU","parola");

        SQL.getSal(7839);
        SQL.getSal(1111);
    }
}
