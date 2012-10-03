helpers = require('../helpers'); AWS = helpers.AWS

describe 'AWS.XMLParser', ->

  parse = (xml, rules, callback) ->
    new AWS.XMLParser(rules).parse(xml, callback)

  describe 'default behavior', ->

    rules = {} # no rules, rely on default parsing behavior

    it 'returns an empty object from an empty document', ->
      xml = '<xml/>'
      parse xml, rules, (data) ->
        expect(data).toEqual({})

    it 'returns empty elements as null', ->
      xml = '<xml><element/></xml>'
      parse xml, rules, (data) ->
        expect(data).toEqual({element:null})

    it 'converts string elements to properties', ->
      xml = '<xml><foo>abc</foo><bar>xyz</bar></xml>'
      parse xml, rules, (data) ->
        expect(data).toEqual({foo:'abc', bar:'xyz'})

    it 'converts nested elements into objects', ->
      xml = '<xml><foo><bar>yuck</bar></foo></xml>'
      parse xml, rules, (data) ->
        expect(data).toEqual({foo:{bar:'yuck'}})

    it 'returns everything as a string (even numbers)', ->
      xml = '<xml><count>123</count></xml>'
      parse xml, rules, (data) ->
        expect(data).toEqual({count:'123'})

    it 'flattens sibling elements of the same name', ->
      xml = '<xml><foo><bar>1</bar><bar>2</bar></foo></xml>'
      parse xml, rules, (data) ->
        expect(data).toEqual({foo:{bar:'1'}})

  describe 'lists', ->

    it 'Converts xml lists of strings into arrays of strings', ->
      xml = """
      <xml>
        <items>
          <member>abc</member>
          <member>xyz</member>
        </items>
      </xml>
      """
      rules = {items:{t:'a',m:{}}}
      parse xml, rules, (data) ->
        expect(data).toEqual({items:['abc','xyz']})

    it 'Observes list member names when present', ->
      xml = """
      <xml>
        <items>
          <item>abc</item>
          <item>xyz</item>
        </items>
      </xml>
      """
      rules = {items:{t:'a',m:{n:'item'}}}
      parse xml, rules, (data) ->
        expect(data).toEqual({items:['abc','xyz']})

  describe 'flattened lists', ->

  describe 'maps', ->

  describe 'booleans', ->

    rules = {enabled:{t:'b'}}

    it 'converts the string "true" in to the boolean value true', ->
      xml = "<xml><enabled>true</enabled></xml>"
      parse xml, rules, (data) ->
        expect(data).toEqual({enabled:true})

    it 'converts the string "false" in to the boolean value false', ->
      xml = "<xml><enabled>false</enabled></xml>"
      parse xml, rules, (data) ->
        expect(data).toEqual({enabled:false})

    it 'converts the empty elements into null', ->
      xml = "<xml><enabled/></xml>"
      parse xml, rules, (data) ->
        expect(data).toEqual({enabled:null})

  describe 'timestamp', ->

  describe 'numbers', ->

  describe 'integers', ->

    rules = {count:{t:'i'}}

    it 'integer parses elements types as integer', ->
      xml = "<xml><count>123</count></xml>"
      parse xml, rules, (data) ->
        expect(data).toEqual({count:123})

    it 'returns null for empty elements', ->
      xml = "<xml><count/></xml>"
      parse xml, rules, (data) ->
        expect(data).toEqual({count:null})

  describe 'renaming elements', ->

  describe 'parsing errors', ->

    it 'throws an error when unable to parse the xml', ->
      xml = 'asdf'
      rules = {}
      message = """
      Non-whitespace before first tag.
      Line: 0
      Column: 1
      Char: a
      """
      error = { code: 'AWS.XMLParser.Error', message: message }
      expect(-> new AWS.XMLParser(rules).parse(xml)).toThrow(error)
