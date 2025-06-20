Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def manSysProp = Java.type('com.laarizag.utils.ManageSystemProperties')
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'laarizag'

  @id:1 @MarvelCharacters @consultaListaPersonajes
  Scenario: T-API-BP-0001-CA01 - Consulta de lista de personajes de un usuario
    Given url baseUrl
    And path username, 'api', 'characters'
    When method get
    Then status 200
    * string responseString = response
    * def setProperty = manSysProp.setProp("ResponseSaved", responseString)

  @id:2 @MarvelCharacters @consultaPersonajeId
  Scenario Outline: T-API-BP-0001-CA02 - Consulta de personaje por usuario por id <id>
    Given url baseUrl
    And path username, 'api', 'characters', <id>
    When method get
    Then status 200
    And assert response.id == 1
    Examples:
      | id |
      | 1  |

