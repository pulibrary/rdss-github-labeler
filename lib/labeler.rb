require 'json'
require 'pry'
require 'octokit'

class Labeler
  def self.apply_labels(repo)
    new(
      client: Octokit::Client.new(:access_token => ENV["GITHUBTOKEN"])
    ).apply_labels(repo)
  end

  attr_reader :client, :labels_hash
  # @param client Octokit::Client
  # @param labels_hash Hash see labels.json for expected structure
  def initialize(client:, labels_hash: nil)
    @client = client
    @labels_hash = labels_hash || load_labels
  end

  # lists all the categories in the labels hash
  def categories
    labels_hash.keys.map(&:to_s)
  end

  # Apply the labels
  # @param repo String The repository, aka "pulibrary/figgy"
  def apply_labels(repo)
    labels_hash.values.each do |h|
      h[:labels].each do |label|
        begin
          client.add_label(repo, label, h[:color])
        rescue Octokit::UnprocessableEntity => e
          if already_exists_error?(e.message)
            client.update_label(repo, label, { color: h[:color] })
          end
        end
      end
    end
  end

  # TODO
  # Delete all the labels and remove them from issues.
  # Only for initializing a new project.
  # @param repo String The repository, aka "pulibrary/figgy"
  def delete_labels(repo)
  end

  private

    def load_labels
      JSON.parse(File.read("labels.json"), symbolize_names: true)
    end

    def already_exists_error?(message)
      message.split("\n")
        .map{ |l| l.strip.split(":")}
        .select{ |pair| pair.first == "code"}
        .flatten[1]
        .strip == "already_exists"
    end
end
