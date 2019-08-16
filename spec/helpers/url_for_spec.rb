describe UrlFor do
  %w[collection media_entry preview].each do |resource|
    it "defines #{resource} method that accepts one #{resource.capitalize} instance as argument" do
      expect(UrlFor).to respond_to(resource).with(1).argument
    end
  end
end
