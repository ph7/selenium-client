#!/usr/bin/env ruby

require 'seletest'
require 'selenium'

class ExampleTest < Test::Unit::TestCase

    def test_something
        open "/inputSuggestAjax.jsf"
		verify_text_present "suggest"
		type "_id0:_id3", "foo"
		keydown "_id0:_id3", 120
		sleep 2
		verify_text_present "foo1"
    end
end