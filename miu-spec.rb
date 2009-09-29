require 'miu.rb'

describe "Make It Ugly" do
  describe "adding braces" do
    it "should work" do
      add_braces_to( <<-eof
                    // some code
                    if (expr)
                        func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (expr)
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
  end
end
