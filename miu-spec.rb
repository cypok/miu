require 'miu.rb'

describe "Make It Ugly" do
  describe "adding braces" do
    %w{if while for}.each do |name|
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
  end
end
