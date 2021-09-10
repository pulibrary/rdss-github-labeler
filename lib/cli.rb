require "thor"
require_relative "labeler"

class LabelerCLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "categories", "list all the category names"
  def categories
    puts Labeler.new(client: nil).categories
  end

  desc "apply_labels [org/repository]", "apply all the labels to given repo"
  def apply_labels(repo)
    Labeler.apply_labels(repo)
  end
end

LabelerCLI.start(ARGV)
