#!/usr/bin/ruby

OPERATORS = /if|while|for/.freeze
COMMENT = /\/\/.*|\/\*.*\*\//.freeze

ONE_LINE_IF = /^( *)((?:#{OPERATORS}) *\(.+?\) *(?:#{COMMENT})?)\n( *)([^;\n]*; *(?:#{COMMENT})?)\n/m
ONE_LINE_IF_REPLACER = '\1\2\n\1{\n\3\4\n\1}\n'.gsub( '\n', "\n" )

def add_braces_to(text)
  text.gsub ONE_LINE_IF, ONE_LINE_IF_REPLACER
end
