*** Settings ***
Documentation  Тест-кейсы, реализующие третье домашнее задание в рамках лекций по robot framework на nexign bootcamp 2021
Metadata  Автор  Михаил Колесников
Metadata  Постановка задачи  Реализовать задание по тестам на обращение к нескольким таблицам и добавление значений, используя метаданные, таймауты и кастомные кейворды, использующие код питона.


Test Setup      Test Setup
Test Teardown   Test Teardown

Resource  resource.robot


*** Variables ***
${select_rows_count_SQL}  ${109}
${select_rows_count_REST}  ${32}

*** Test Cases ***
Multiple base search SQL test
  [Documentation]  Проверка поиска в двух таблицах при помощи SQL запроса

  ${params}    create dictionary    amount=5
  ${python_result}=  PY_HW.Get_multiple_selection_result  ${params}[amount]
  ${python_count}=  get length  ${python_result}


Table change SQL request
  [Teardown]  Test Teardown Insertions Cleaning
  [Documentation]  Проверка поиска по таблице, предварительно измененной SQL запросом
  ${insertion_params}  create dictionary  category=17  name=Adult only
  ${pre_size} =  PY_HW.Get_table_size
  ${python_result}=  PY_HW.Insert_row_into_table  ${insertion_params}[category]  ${insertion_params}[name]
  ${post_size} =  PY_HW.Get_table_size
  PY_HW.Compare_sizes_before_and_after_changes  ${pre_size}  ${post_size}  ${1}

*** Keywords ***

Test Teardown Insertions Cleaning
    ${removing_params}  create dictionary  category=17
    ${removing_SQL}  set variable  DELETE FROM bootcamp.categories where category=17 returning ''
    @{removing_result}  DB.Execute Sql String  ${removing_SQL}  &{removing_params}
    Test Teardown