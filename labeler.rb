require 'json'

class Labeler
  LABELS = JSON.parse(File.read("labels.json"), symbolize_names: true)

  def print_categories
    puts LABELS.map{ |c| c[:category]}
  end
end

Labeler.new.print_categories
