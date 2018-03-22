require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LoginHelper. For example:
#
# describe LoginHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  
  describe "set_sign_in_required" do
    it "sets the correct flash notice" do
      expect(set_sign_in_required()).to eq('Log in with Twitter to use this application')
    end
  end

end
