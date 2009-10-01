#!/usr/bin/ruby

COMMENT = /\/\/.*?/.freeze

ONE_LINE_IF = /^( *)((?:else|(?:if|while|for) *\([^;]+?\)) *(?:#{COMMENT})?)\n( *)([^;\n]*; *(?:#{COMMENT})?)\n/m
ONE_LINE_IF_REPLACER = '\1\2\n\1{\n\3\4\n\1}\n'.gsub( '\n', "\n" )

RIGHT_CONSTANT = /((?:if|while) *\( *)([^&|]*?)( *[!=]{2,2} *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_REPLACER = '\1\4\3\2\5'

def add_braces_to(text)
  text.gsub ONE_LINE_IF, ONE_LINE_IF_REPLACER
end

def join_one_line_if_regexp_parts(parts)
  parts[0]+parts[1]+"\n"+parts[2]+parts[3]+"\n"
end

def swap_conditions_in(text)
  text.gsub RIGHT_CONSTANT, RIGHT_CONSTANT_REPLACER
end

def join_right_constant_regexp_parts(parts)
  parts * ""
end

def process_braces(text)
  scans = text.scan(ONE_LINE_IF)
  if scans.size > 0
    puts "Следующий pretty-код будет заменен на ugly-скобочный-код"
    scans.map {|s| join_one_line_if_regexp_parts( s )}.each do |scan|
      puts "------------------------------"
      puts "Есть:", scan, "Будет:", add_braces_to( scan )
    end
    puts "------------------------------"
    puts "Подтверждаете изменения? (yes/да/no/нет)"
    answer = STDIN.readline.strip
    %w{y yes ok да ага конечно окей ок пох}.include?( answer ) ? add_braces_to( text ) : text
  else
    text
  end
end

def process_constants(text)
  scans = text.scan(RIGHT_CONSTANT)
  if scans.size > 0
    puts "Следующий pretty-код будет заменен на ugly-константы-слева-код"
    scans.map {|s| join_right_constant_regexp_parts( s )}.each do |scan|
      puts "------------------------------"
      puts "Есть:", scan, "Будет:", swap_conditions_in( scan )
    end
    puts "------------------------------"
    puts "Подтверждаете изменения? (yes/да/no/нет)"
    answer = STDIN.readline.strip
    %w{y yes ok да ага конечно окей ок пох}.include?( answer ) ? swap_conditions_in( text ) : text
  else
    text
  end
end

if __FILE__ == $0
  ARGV.each do |s|
    text = File.open(s) { |file| process_constants( process_braces( file.read ) ) }
    File.new(s, "w").write text
  end
end
