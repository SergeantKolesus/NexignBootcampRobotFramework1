*** Settings ***
Test Setup      Test Setup
Test Teardown   Test Teardown
Library         RequestsLibrary     WITH NAME   Req
Library         PostgreSQLDB        WITH NAME   DB
Library  JsonValidator

*** Variables ***
${select_rows_count_SQL}  ${109}
${select_rows_count_REST}  ${32}

*** Test Cases ***
Multiple base search SQL test
  [Documentation]  Проверка поиска в двух таблицах при помощи SQL запроса

  ${params}    create dictionary    amount=5
  ${SQL}          set variable         SELECT DISTINCT prod.prod_id, title FROM bootcamp.inventory AS inv INNER JOIN bootcamp.products AS prod ON inv.prod_id=prod.prod_id WHERE "quan_in_stock" < %(amount)s
  @{result}    DB.Execute Sql String Mapped   ${SQL}   &{params}
  ${count} =  get length  ${result}

  should be equal as integers  ${count}  ${select_rows_count_SQL}

Multiple base search RESP request
  [Documentation]  Проверка поиска в двух таблицах при помощи RESP запроса
  ${resp}      Req.GET On Session     alias    /products?  params=select=title,inventory(quan_in_stock)&title=like.ACADEMY*AD*
  ${title}   get elements   ${resp.json()}    $..title
  ${count}  get length  ${title}
  should be equal as integers  ${count}  ${select_rows_count_REST}


Table change SQL request
  [Teardown]  Test Teardown Insertions Cleaning
  [Documentation]  Проверка поиска по таблице, предварительно измененной SQL запросом
  ${insertion_params}  create dictionary  category=17  name=Adult only
  ${insertion_SQL}  set variable  INSERT INTO bootcamp.categories (category, categoryname) values (%(category)s, %(name)s) returning category

  ${selection_params}  create dictionary  category=17
  ${selection_SQL}  set variable  SELECT category FROM bootcamp.categories

  ${raw_table_elements_count_SQL}  set variable  SELECT COUNT(category) FROM bootcamp.categories
  @{raw_table_elements_count}  DB.Execute Sql String  ${raw_table_elements_count_SQL}

  ${summary_params}  create dictionary  category=17  name=Adult only
  ${summary_SQL}  set variable  ${insertion_SQL}; ${selection_SQL}
  @{summary_result}  DB.Execute Sql String Mapped  ${summary_SQL}  &{summary_params}
  ${result_length} =  get length  ${summary_result}

  ${proper_count}  set variable  @{raw_table_elements_count}[0]
  ${proper_count} =  evaluate  ${proper_count} + ${1}
  should be equal as integers  ${proper_count}  ${result_length}

Table change REST request
  [Teardown]  Test Teardown Insertions Cleaning
  [Documentation]  Проверка поиска по таблице, предварительно измененной REST запросом
  &{data}=    Create dictionary  categoryname=Adult only  category=17
  ${resp}=    Req.POST On Session    alias  /categories  json=${data}  expected_status=anything
  Status Should Be                 201  ${resp}

*** Keywords ***
Test Setup
    Req.Create session                   alias       http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432

Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql

Test Teardown Insertions Cleaning
    ${removing_params}  create dictionary  category=17
    ${removing_SQL}  set variable  DELETE FROM bootcamp.categories where category=17 returning ''
    @{removing_result}  DB.Execute Sql String  ${removing_SQL}  &{removing_params}
    Test Teardown