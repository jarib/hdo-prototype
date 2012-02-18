class Category
  def self.from_xml(path)
    doc = Nokogiri::XML.parse(File.read(path))
    doc.css("emne_liste > emne").map { |node| new node }
  end

  def initialize(node)
    @node = node
  end

  def id
    @node.css("id").first.text
  end

  def main_category?
    @node.css("er_hovedemne").first.text == "true"
  end

  def name
    @node.css("navn").first.text
  end

  def sub_categories
    subs = @node.css("underemne_liste > emne").map { |e| self.class.new e }
    subs.sort_by { |e| e.name }
  end
end
