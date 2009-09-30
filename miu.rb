#!/usr/bin/ruby

OPERATORS = /if|while|for/.freeze
COMMENT = /\/\/.*|\/\*.*\*\//.freeze

ONE_LINE_IF = /^( *)((?:#{OPERATORS}) *\([^;]+?\) *(?:#{COMMENT})?)\n( *)([^;\n]*; *(?:#{COMMENT})?)\n/m
ONE_LINE_IF_REPLACER = '\1\2\n\1{\n\3\4\n\1}\n'.gsub( '\n', "\n" )

def add_braces_to(text)
  text.gsub ONE_LINE_IF, ONE_LINE_IF_REPLACER
end

def join_regexp_parts(parts)
  parts[0]+parts[1]+"\n"+parts[2]+parts[3]+"\n"
end

def process_braces(text)
  scans = text.scan(ONE_LINE_IF)
  if scans.size > 0
    puts "Следующий pretty-код будет заменен на ugly-скобочный-код"
    scans.map {|s| join_regexp_parts( s )}.each do |scan|
      puts "------------------------------"
      puts "Есть:", scan, "Будет:", add_braces_to( scan )
    end
    puts "------------------------------"
    puts "Подтверждаете изменения? (yes/да/no/нет)"
    answer = STDIN.readline.strip
    %w{y yes ok да ага конечно окей ок пох}.include?( answer ) ? add_braces_to( text ) : text
  end
end

if __FILE__ == $0
  ARGV.each do |s|
    text = ""
    File.open(s) do |file|
      text = process_braces( file.read )
    end
    File.new(s, "w").write text
  end
end
