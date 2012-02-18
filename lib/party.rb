class Party
  attr_reader :id, :name

  def self.from_xml(path)
    p :path => path
    doc = Nokogiri::XML.parse(File.read(path))
    doc.css("parti").map { |node| new node }
  end

  def initialize(node)
    @node = node
  end

  def name
    @node.css("navn").text
  end

  def id
    @node.css("id").text
  end
end