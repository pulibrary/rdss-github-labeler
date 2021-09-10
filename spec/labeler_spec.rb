require 'pry'
require 'labeler'
require 'octokit'

RSpec.describe Labeler do
  let(:client) { instance_double("Octocat::Client") }

  describe "#categories" do
    it "returns the category names" do
      labeler = described_class.new
      expect(labeler.categories).to include("category1")
    end
  end

  describe ".apply_labels" do
    it "calls the instance method" do
      labels_hash = {}
      instance = described_class.new(client: client, labels_hash: labels_hash)
      allow(described_class).to receive(:new).and_return(instance)
      described_class.apply_labels("sample_repo")
      expect(described_class).to have_received(:new)
    end
  end

  describe "#apply_labels" do
    it "applies labels" do
      labels_hash = {
        :category1=>{:color=>"ff5050", :labels=>["bug", "security"]},
        :category5=>{:color=>"44cec0", :labels=>["refactor"]}
      }
      allow(client).to receive(:add_label)
      labeler = described_class.new(client: client, labels_hash: labels_hash)
      repo = "sample_repo"
      labeler.apply_labels(repo)
      expect(client).to have_received(:add_label).with(repo, "bug", "ff5050")
      expect(client).to have_received(:add_label).with(repo, "security", "ff5050")
      expect(client).to have_received(:add_label).with(repo, "refactor", "44cec0")
    end

    context "when the token already exists" do
      it "updates the color" do
        labels_hash = {
          :category5=>{:color=>"44cec0", :labels=>["refactor"]}
        }
        response_hash = {
          method: "POST",
          url: "https://api.github.com/repos/hackartisan/dotfiles-local/labels",
          status: 422,
          body: "Validation Failed\nError summary:\n  resource: Label\n  code: already_exists\n  field: name // See: https://docs.github.com/rest/reference/issues#create-a-label"
        }
        allow(client).to receive(:add_label).and_raise(Octokit::UnprocessableEntity.new(response_hash))
        allow(client).to receive(:update_label)

        labeler = described_class.new(client: client, labels_hash: labels_hash)
        repo = "sample_repo"
        labeler.apply_labels(repo)
        expect(client).to have_received(:add_label).with(repo, "refactor", "44cec0")
        expect(client).to have_received(:update_label).with(repo, "refactor", {color: "44cec0"})
      end
    end
  end

  describe ".clear_labels" do
    it "calls the instance method" do
      allow(client).to receive(:labels).and_return([])
      instance = described_class.new(client: client, labels_hash: {})
      allow(described_class).to receive(:new).and_return(instance)
      described_class.clear_labels("sample_repo")
      expect(described_class).to have_received(:new)
    end
  end

  describe "#clear_labels" do
    it "applies labels" do
      labels = [
        { :id=>3339035774,
          :node_id=>"MDU6TGFiZWwzMzM5MDM1Nzc0",
          :url=> "https://api.github.com/repos/pulibrary/dls-github-label-maker/labels/bug",
          :name=>"bug",
          :color=>"ff5050",
          :default=>true,
          :description=>"Something isn't working"},
        { :id=>3342338650,
          :node_id=>"MDU6TGFiZWwzMzQyMzM4NjUw",
          :url=> "https://api.github.com/repos/pulibrary/dls-github-label-maker/labels/refactor",
          :name=>"refactor",
          :color=>"44cec0",
          :default=>false,
          :description=>nil}
      ]
      allow(client).to receive(:labels).and_return(labels)
      allow(client).to receive(:delete_label!)
      labeler = described_class.new(client: client)
      repo = "sample_repo"
      labeler.clear_labels(repo)
      expect(client).to have_received(:delete_label!).with(repo, "bug")
      expect(client).to have_received(:delete_label!).with(repo, "refactor")
    end
  end
end
