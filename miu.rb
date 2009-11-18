#!/usr/bin/ruby

COMMENT = /\/\/[^\n]*?/.freeze

ONE_LINE_IF = /^( *)((?:else|(?:if|while) *\([^;]+?\)|for *\([^\n]+?\)) *(?:#{COMMENT})?)\n( *)([^;{}]*; *(?:#{COMMENT})?)\n/m

RIGHT_CONSTANT = /((?:if|while) *\( *)([^&|\n]*?)( *(?:>=?|<=?|==|!=) *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_L = /((?:if|while) *\( *)([^&|\n]*?)( *< *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_LE = /((?:if|while) *\( *)([^&|\n]*?)( *<= *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_G = /((?:if|while) *\( *)([^&|\n]*?)( *> *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_GE = /((?:if|while) *\( *)([^&|\n]*?)( *>= *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/
RIGHT_CONSTANT_E_NE = /((?:if|while) *\( *)([^&|\n]*?)( *[!=]= *)([A-Z0-9_]+)( *\) *(?:#{COMMENT})?)$/

def add_braces_to(text)
  text.gsub! ONE_LINE_IF, '\1\2\n\1{\n\3\4\n\1}\n'.gsub( '\n', "\n" )
  text
end

def join_one_line_if_regexp_parts(parts)
  parts[0]+parts[1]+"\n"+parts[2]+parts[3]+"\n"
end

def swap_conditions_in(text)
  text.gsub! RIGHT_CONSTANT_L, '\1\4 > \2\5'
  text.gsub! RIGHT_CONSTANT_LE, '\1\4 >= \2\5'
  text.gsub! RIGHT_CONSTANT_G, '\1\4 < \2\5'
  text.gsub! RIGHT_CONSTANT_GE, '\1\4 <= \2\5'
  text.gsub! RIGHT_CONSTANT_E_NE, '\1\4\3\2\5'
  text
end

def join_right_constant_regexp_parts(parts)
  parts * ""
end

def process_braces(text)
  scans = text.scan(ONE_LINE_IF)
  if scans.size > 0
    puts "Following pretty-code would be replaced with ugly-braced-code"
    scans.map {|s| join_one_line_if_regexp_parts( s )}.each do |scan|
      puts "------------------------------"
      puts "> It is:", scan, "> It will be:", add_braces_to( scan )
    end
    puts "------------------------------"
    puts ">> Confirm? (y/yes/n/no)"
    answer = STDIN.readline.strip
    %w{y yes ok}.include?( answer ) ? add_braces_to( text ) : text
  else
    text
  end
end

def process_constants(text)
  scans = text.scan(RIGHT_CONSTANT)
  if scans.size > 0
    puts "Following pretty-code would be replaced with ugly-constants-on-left-code"
    scans.map {|s| join_right_constant_regexp_parts( s )}.each do |scan|
      puts "------------------------------"
      puts "> It is:", scan, "> It will be:", swap_conditions_in( scan )
    end
    puts "------------------------------"
    puts ">> Confirm? (y/yes/n/no)"
    answer = STDIN.readline.strip
    %w{y yes ok}.include?( answer ) ? swap_conditions_in( text ) : text
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
