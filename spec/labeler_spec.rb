require 'pry'
require 'labeler'

RSpec.describe Labeler do
  let(:client) { instance_double("Octocat::Client") }

  describe "#categories" do
    it "returns the category names" do
      labeler = Labeler.new(client: client)
      expect(labeler.categories).to include("category1")
    end
  end

  describe "#apply_labels" do
    it "applies labels" do
      labels_hash = {
        :category1=>{:color=>"ff5050", :labels=>["bug", "security"]},
        :category5=>{:color=>"44cec0", :labels=>["refactor"]}
      }
      allow(client).to receive(:add_label)
      labeler = Labeler.new(client: client, labels_hash: labels_hash)
      repo = "not_a_valid_repo"
      labeler.apply_labels(repo)
      expect(client).to have_received(:add_label).with(repo, "bug", "ff5050")
      expect(client).to have_received(:add_label).with(repo, "security", "ff5050")
      expect(client).to have_received(:add_label).with(repo, "refactor", "44cec0")
    end
  end
end
