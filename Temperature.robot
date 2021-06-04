*** Variables ***
&{Temperature_pairs}  ${0}=${32}
...                   ${350.0}=${662}
...                   ${-32.0}=${-25.6}
...                   ${100.0}=${212}

@{Temperatures}  ${0}  ${350}  ${-32}  ${100}
*** Test Cases ***
Check temperature convertion formula
  import library  Collections

  FOR  ${temperature}  IN  @{Temperatures}
    ${val}=  Convert Celsius to Fahrenheit  ${temperature}
    should be equal  ${val}  ${Temperature_pairs}[${temperature}]
  END

*** Keywords ***
Convert Celsius to Fahrenheit
  [Arguments]  ${celsius_temp}
  ${fahrenheit_temp} =  evaluate  ${9/5} * ${celsius_temp} + ${32}
  [Return]  ${fahrenheit_temp}