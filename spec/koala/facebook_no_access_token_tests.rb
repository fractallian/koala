class FacebookNoAccessTokenTests < Test::Unit::TestCase
  
  describe "Koala GraphAPI without an access token" do
    before :each do
      @graph = Koala::Facebook::GraphAPI.new
    end
  
    it "should get public data about a user" do
      result = @graph.get_object("koppel")
      # the results should have an ID and a name, among other things
      (result["id"] && result["name"]).should
    end

    it "should not get private data about a user" do
      result = @graph.get_object("koppel")
      # updated_time should be a pretty fixed test case
      result["updated_time"].should be_nil
    end

  
    it "should get public data about a Page" do
      result = @graph.get_object("contextoptional")
      # the results should have an ID and a name, among other things
      (result["id"] && result["name"]).should
    end
  
    it "should not be able to get data about 'me'" do
      lambda { @graph.get_object("me") }.should raise_error(Koala::Facebook::APIError)
    end
  
    it "should be able to get multiple objects" do
      results = @graph.get_objects(["contextoptional", "naitik"])
      results.length.should == 2
    end
  
    it "shouldn't be able to access connections from users" do
      lambda { @graph.get_connections("lukeshepard", "likes") }.should raise_error(Koala::Facebook::APIError)
    end

    it "should be able to access connections from public Pages" do
      result = @graph.get_connections("contextoptional", "likes")
      result["data"].should be_a(Array)
    end
  
    it "should not be able to put an object" do
      lambda { @result = @graph.put_object("lukeshepard", "feed", :message => "Hello, world") }.should raise_error(Koala::Facebook::APIError)
      puts "Error!  Object #{@result.inspect} somehow put onto Luke Shepard's wall!" if @result
    end

    # these are not strictly necessary as the other put methods resolve to put_object, but are here for completeness
    it "should not be able to post to a feed" do
      (lambda do
        attachment = {:name => "Context Optional", :link => "http://www.contextoptional.com/"}
        @result = @graph.put_wall_post("Hello, world", attachment, "contextoptional") 
      end).should raise_error(Koala::Facebook::APIError)
      puts "Error!  Object #{@result.inspect} somehow put onto Context Optional's wall!" if @result
    end

    it "should not be able to comment on an object" do
      # random public post on the ContextOptional wall
      lambda { @result = @graph.put_comment("7204941866_119776748033392", "The hackathon was great!") }.should raise_error(Koala::Facebook::APIError)
      puts "Error!  Object #{@result.inspect} somehow commented on post 7204941866_119776748033392!" if @result    
    end

    it "should not be able to like an object" do
      lambda { @graph.put_like("7204941866_119776748033392") }.should raise_error(Koala::Facebook::APIError)
    end


    # DELETE
    it "should not be able to delete posts" do 
      # test post on the Ruby SDK Test application
      lambda { @result = @graph.delete_object("115349521819193_113815981982767") }.should raise_error(Koala::Facebook::APIError)
    end

    # SEARCH
    it "should be able to search" do
      result = @graph.search("facebook")
      result["data"].should be_an(Array)
    end

    # API
    # the above tests test this already, but we should consider additional api tests
    
  end # describe

end #class
  