#!/usr/bin/ruby

def addn(s)
  s.gsub '\n', "\n"
end

def add_braces_to(text)
  text.gsub /^( *)(if *\(.*\) *)\n(.+)\n/, addn( '\1\2\n\1{\n\3\n\1}\n' )
end

