*** Settings ***
Library         RequestsLibrary     WITH NAME   Req
Library         PostgreSQLDB        WITH NAME   DB
Library         JsonValidator

Resource  Python_libs.robot

*** Keywords ***
Test Setup
    Req.Create session                   alias       http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432

Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql