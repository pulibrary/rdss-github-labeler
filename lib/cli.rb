require "thor"
require_relative "labeler"

class LabelerCLI < Thor
  desc "categories", "list all the category names"
  def categories
    puts Labeler.new(client: nil).categories
  end
end

LabelerCLI.start(ARGV)
