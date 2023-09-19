require "pry"
require "labeler"
require "octokit"

RSpec.describe Labeler do
  let(:client) { instance_double("Octokat::Client") }

  describe "instantiation" do
    it "creates an octokit client" do
      allow(Octokit::Client).to receive(:new)
      allow(Open3).to receive(:capture2).and_return("token")
      described_class.new
      expect(Octokit::Client).to have_received(:new)
    end
  end

  describe "#categories" do
    it "returns the category names" do
      labeler = described_class.new(client: client)
      expect(labeler.categories).to include("board")
    end
  end

  describe "#list_labels" do
    it "returns a list of name / color pairs" do
      octokit_result = [
        { id: 654_012_521,
          node_id: "MDU6TGFiZWw2NTQwMTI1MjE=",
          url: "https://api.github.com/repos/pulibrary/figgy/labels/bug",
          name: "bug",
          color: "ff5050",
          default: true,
          description: "" },
        { id: 654_012_527,
          node_id: "MDU6TGFiZWw2NTQwMTI1Mjc=",
          url: "https://api.github.com/repos/pulibrary/figgy/labels/wontfix",
          name: "wontfix",
          color: "ffffff",
          default: true,
          description: nil }
      ]
      allow(client).to receive(:labels).and_return(octokit_result)
      labeler = described_class.new(client: client)
      expect(labeler.list_labels("sample_repo")).to include(["bug", "ff5050"])
    end
  end

  describe "#apply_labels" do
    it "applies labels" do
      labels_hash = {
        category1: { color: "ff5050", labels: ["bug", "security"] },
        category5: { color: "44cec0", labels: ["refactor"] }
      }
      allow(client).to receive(:add_label)
      labeler = described_class.new(client: client, labels_hash: labels_hash)
      repos = ["sample_repo1", "sample_repo2"]
      labeler.apply_labels(repos)
      expect(client).to have_received(:add_label).with("sample_repo1", "bug", "ff5050")
      expect(client).to have_received(:add_label).with("sample_repo1", "security", "ff5050")
      expect(client).to have_received(:add_label).with("sample_repo1", "refactor", "44cec0")
      expect(client).to have_received(:add_label).with("sample_repo2", "bug", "ff5050")
      expect(client).to have_received(:add_label).with("sample_repo2", "security", "ff5050")
      expect(client).to have_received(:add_label).with("sample_repo2", "refactor", "44cec0")
    end

    context "when the token already exists" do
      it "updates the color" do
        labels_hash = {
          category5: { color: "44cec0", labels: ["refactor"] }
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
        repos = ["sample_repo1", "sample_repo2"]
        labeler.apply_labels(repos)
        expect(client).to have_received(:add_label).with("sample_repo1", "refactor", "44cec0")
        expect(client).to have_received(:update_label).with("sample_repo1", "refactor", { color: "44cec0" })
        expect(client).to have_received(:add_label).with("sample_repo2", "refactor", "44cec0")
        expect(client).to have_received(:update_label).with("sample_repo2", "refactor", { color: "44cec0" })
      end
    end
  end

  describe "#delete_label" do
    it "uses the octokit method" do
      allow(client).to receive(:delete_label!)
      labeler = described_class.new(client: client)
      labeler.delete_label(["sample_repo"], "on hold")
      expect(client).to have_received(:delete_label!).with("sample_repo", "on hold")
    end
  end

  describe "#clear_labels" do
    it "applies labels" do
      labels = [
        { id: 3_339_035_774,
          node_id: "MDU6TGFiZWwzMzM5MDM1Nzc0",
          url: "https://api.github.com/repos/pulibrary/dls-github-label-maker/labels/bug",
          name: "bug",
          color: "ff5050",
          default: true,
          description: "Something isn't working" },
        { id: 3_342_338_650,
          node_id: "MDU6TGFiZWwzMzQyMzM4NjUw",
          url: "https://api.github.com/repos/pulibrary/dls-github-label-maker/labels/refactor",
          name: "refactor",
          color: "44cec0",
          default: false,
          description: nil }
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
