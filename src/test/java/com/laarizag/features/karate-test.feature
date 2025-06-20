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

  @id:2 @MarvelCharacters @consultaPersonajeId
  Scenario Outline: T-API-BP-0001-CA02 - Consulta correcta de personaje por usuario por id <id>
    Given url baseUrl
    And path username, 'api', 'characters', <id>
    When method get
    Then status 200
    And assert response.id == 1
    Examples:
      | id |
      | 1  |

  @id:3 @MarvelCharacters @consultaPersonajeIdError
  Scenario Outline: T-API-BP-0001-CA03 - Consulta incorrecta de personaje por usuario por id <id> o id <id> no existe
    Given url baseUrl
    And path username, 'api', 'characters', <id>
    When method get
    Then status 404
    And match response == { error: '#present' }
    Examples:
      | id |
      | -1 |

  @id:4 @MarvelCharacters @creacionPersonajeExitosa
  Scenario: T-API-BP-0002-CA01 - Creación de personaje exitosa
    * header content-type = 'application/json'
    Given url baseUrl
    And path username, 'api', 'characters'
    And def character = read('classpath:./data/CharacterData.json')
    And request character
    When method post
    Then status 201
    * string responseString = response
    * def setProperty = manSysProp.setProp("lastCharacterCreated", responseString)
    And match response contains { id: '#present' }
    And match response !contains { error: '#present' }

  @id:5 @MarvelCharacters @creacionPersonajeNombreDuplicado
  Scenario: T-API-BP-0002-CA02 - Creación de personaje incorrecta porque ya existe un héroe con el mismo nombre
    * header content-type = 'application/json'
    Given url baseUrl
    And path username, 'api', 'characters'
    And def character = read('classpath:./data/CharacterData.json')
    And request character
    When method post
    Then status 400
    And match response !contains { id: '#present' }
    And match response contains { error: '#present' }

  @id:6 @MarvelCharacters @creacionPersonajeInformaciónIncompleta
  Scenario: T-API-BP-0002-CA03 - Creación de personaje incorrecta porque no cuenta con toda la información necesaria
    * header content-type = 'application/json'
    Given url baseUrl
    And path username, 'api', 'characters'
    And def character = read('classpath:./data/MissingCharacterData.json')
    * karate.remove('character', 'description')
    And request character
    When method post
    Then status 400
    * print response

  @id:9 @MarvelCharacters @borradoPersonajeExitoso
  Scenario: T-API-BP-0004-CA01 - Borrado exitoso de personaje
    * json lastResponse = manSysProp.getProp("lastCharacterCreated")
    * print lastResponse
    Given url baseUrl
    And path username, 'api', 'characters', lastResponse.id
    When method delete
    Then status 204