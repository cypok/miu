#!/usr/bin/ruby

OPERATORS = /if|while|for/.freeze
COMMENT = /\/\/.*|\/\*.*\*\//

def addn(s)
  s.gsub '\n', "\n"
end

def add_braces_to(text)
  text.gsub /^( *)((?:#{OPERATORS}) *\(.+\) *(?:#{COMMENT})?)\n( *)([^;]*; *(?:#{COMMENT})?)\n/m, addn( '\1\2\n\1{\n\3\4\n\1}\n' )
end


