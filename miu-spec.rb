require 'miu.rb'

describe "Make It Ugly" do
  describe "adding braces" do
    it "should replace simple 'if (...)\\nblah'" do
      add_braces_to( <<-eof
                    // some code
                    if (true)
                        blah();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (true)
                    {
                        blah();
                    }
                    // some other
      eof
    end

    it "should replace simple 'if (big condition)\\nblah'" do
      add_braces_to( <<-eof
                    // some code
                    if (really_big_condition() != false)
                        blah();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (really_big_condition() != false)
                    {
                        blah();
                    }
                    // some other
      eof
    end

    it "should replace simple 'if (...)\\nblah(...)'" do
      add_braces_to( <<-eof
                    // some code
                    if (true)
                      blah( some, args );
                      stupid_func();
                    // some other
      eof
      ).should == <<-eof
                    // some code
                    if (true)
                    {
                      blah( some, args );
                    }
                      stupid_func();
                    // some other
      eof
    end
  end
end
