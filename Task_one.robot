

*** Variables ***
#@{TestList}  ${1}  ${4}  ${2}  ${01}
@{TestIntList}  ${2}  ${4}  ${1}  ${5}  ${4}
@{TestStringList}  line1  line2  line1  line4


*** Test Cases ***
Min and max test
  @{res}  Get minmax from list  @{TestIntList}
  log  Получено минимальное значение ${res}[0] и максимальное значение ${res}[1]


Uniqie sublist test with get function
  @{sublist}  Get unique vals from list  @{TestStringList}
  log many  Из списка выл выделен следующий подсписок, содержащий все уникальные значения исходного @{sublist}

#В задании сказано "Тест по выводу уникальных значений", поэтому сначала я сделал keyword выводящий результат внутри себя.
#Я понимаю, что кейворд это не тест, но удалять было жалко.
#Мне его было немного жалко, поэтому я его оставил и убрал в отдельный тест.
Unique sublist test with print fuction
  Print unique vals from list  @{TestIntList}

List sum test
  ${sum}  Get list sum  @{TestIntList}
  log  Сумма значений заданного списка равна ${sum}

*** Keywords ***
Get minmax from list
  [Arguments]  @{list}
  ${min}  set variable  ${list}[0]
  ${max}  set variable  ${list}[0]
  FOR  ${val}  IN  @{list}
    IF  ${val} < ${min}
      ${min}  set variable  ${val}
    END

    IF  ${val} > ${max}
      ${max}  set variable  ${val}
    END
    #Log  ${val}
  END
  #Log    ${min}
  #Log    ${max}
  @{res}  create list  ${min}  ${max}
  [Return]  @{res}

Print unique vals from list
  [Arguments]  @{list}
  import library  Collections
  @{res}  create list
  FOR  ${val}  IN  @{list}
#    log  ${val}
#    log many  @{list}
    IF  ${val} not in @{res}
#      log  ${val}
#      log many  @{res}
      Append To List  ${res}  ${val}
    END
  END

  log many  @{res}

Get unique vals from list
  [Arguments]  @{list}
#  log many  @{list}
  import library  Collections
  @{res}  create list  ${list}[0]
  FOR  ${val}  IN  @{list}
    IF  '${val}' not in @{res}
#      log  ${val}
#      log many  @{res}
      Append To List  ${res}  ${val}
    END
#    log  ${val}
  END

  [return]  ${res}

Get list sum
  [Arguments]  @{list}
  #@{res}  create list
  import library  Collections
  ${sum}  set variable  ${0}
  FOR  ${val}  IN  @{list}
#    log  ${val}
#    log  ${sum}
    ${sum} =  evaluate  ${sum} + ${val}
  END

  [return]  ${sum}