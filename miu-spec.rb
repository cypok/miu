require 'miu.rb'

describe "Make It Ugly" do
  describe "adding braces" do
    %w{if while}.each do |name|
      it "should work with #{name.upcase}" do
        add_braces_to( <<-eof
                      // some code
                      #{name} (expr)
                          func();
                      // some other
        eof
        ).should == <<-eof
                      // some code
                      #{name} (expr)
                      {
                          func();
                      }
                      // some other
        eof
      end
    end

    it "should work with FOR" do
      add_braces_to( <<-eof
                    // some code
                    for (expr; expr < k; ++expr)
                        func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    for (expr; expr < k; ++expr)
                    {
                        func();
                    }
                    // some other
      eof
    end

    it "should replace IFs with function calls" do
      add_braces_to( <<-eof
                    // some code
                    if (call() != false)
                        expr();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (call() != false)
                    {
                        expr();
                    }
                    // some other
      eof
    end

    it "should replace IFs with division" do
      add_braces_to( <<-eof
                    // some code
                    if (a/5 != 1)
                        expr();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (a/5 != 1)
                    {
                        expr();
                    }
                    // some other
      eof
    end

    it "should work with multy line functions" do
      add_braces_to( <<-eof
                    // some code
                    if (expr)
                      func( a,
                            b
                      );
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr)
                    {
                      func( a,
                            b
                      );
                    }
                    // some other
      eof
    end

    it "should work with comments after func" do
      add_braces_to( <<-eof
                    // some code
                    if (expr)
                      func(); // comment
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr)
                    {
                      func(); // comment
                    }
                    // some other
      eof
    end

    it "should work with comments after if" do
      add_braces_to( <<-eof
                    // some code
                    if (expr) // comment
                      func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr) // comment
                    {
                      func();
                    }
                    // some other
      eof
    end

    it "should work with comments on next line after if" do
      add_braces_to( <<-eof
                    // some code
                    if (expr)
                      // comment
                      func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr)
                    {
                      // comment
                      func();
                    }
                    // some other
      eof
    end

    it "should work with multy line IFs" do
      add_braces_to( <<-eof
                    // some code
                    if (expr() &&
                        some_other())
                      func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr() &&
                        some_other())
                    {
                      func();
                    }
                    // some other
      eof
    end

    it "should not replace already braced" do
      add_braces_to( <<-eof
                    // some code
                    if (false)
                    {
                        expr();
                    }
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (false)
                    {
                        expr();
                    }
                    // some other
      eof
    end

    it "should replace IFs and ELSEs" do
      add_braces_to( <<-eof
                    // some code
                    if (val != false)
                        expr();
                    else
                        other();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (val != false)
                    {
                        expr();
                    }
                    else
                    {
                        other();
                    }
                    // some other
      eof
    end

    it "should not process ifs in more than one lines" do
      add_braces_to( <<-eof
                    if (val > false)
                        if (other == ERROR)
      eof
      ).should == <<-eof
                    if (val > false)
                        if (other == ERROR)
      eof
    end

    it "should not add unnecessery braces [WAS A BUG]" do
      add_braces_to( <<-eof
                    if ( SMTH )
                    {
                        // blah (really)
                        // blah
                        foo();
                    }
      eof
      ).should == <<-eof
                    if ( SMTH )
                    {
                        // blah (really)
                        // blah
                        foo();
                    }
      eof
    end
  end

  describe "swapping constants at right" do
    %w{if while}.each do |val|
      it "should work with '#{val}'" do
        swap_conditions_in("#{val}(value == ZERO)").should == "#{val}(ZERO == value)"
      end
    end

    %w{assert _ASSERT}.each do |val|
      it "should work with '#{val}'" do
        swap_conditions_in("#{val}(value == ZERO);").should == "#{val}(ZERO == value);"
      end
    end

    %w{== !=}.each do |val|
      it "should work with '#{val}'" do
        swap_conditions_in("if(value #{val} ZERO)").should == "if(ZERO #{val} value)"
      end
    end

    it "should process function calls" do
      swap_conditions_in("if (func( a ) == ZERO)").should == "if (ZERO == func( a ))"
    end

    it "should process function calls" do
      swap_conditions_in("if (func(2+4, A == B) == ZERO)").should == "if (ZERO == func(2+4, A == B))"
    end

    it "should not process double if's" do
      swap_conditions_in("if (a && c == D)").should == "if (a && c == D)"
    end

    it "should work with . and ->" do
      swap_conditions_in("if (result.smth->a != OK)").should == "if (OK != result.smth->a)"
    end

    it "should work with []" do
      swap_conditions_in("if (result[i] != OK)").should == "if (OK != result[i])"
    end

    it "should work with '>>'" do
      swap_conditions_in("if (i << 2 != OK)").should == "if (OK != i << 2)"
    end

    it "should work with comments" do
      swap_conditions_in("if (var != OK) // it's great").should == "if (OK != var) // it's great"
    end

    it "should work with '<='" do
      swap_conditions_in("if (var <= OK) // it's great").should == "if (OK >= var) // it's great"
    end

    it "should work with '>'" do
      swap_conditions_in("if (var > OK) // it's great").should == "if (OK < var) // it's great"
    end
  end
end
