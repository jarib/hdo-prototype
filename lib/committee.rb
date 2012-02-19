class Committee

  def self.from_xml(path)
    doc = Nokogiri::XML.parse(File.read(path))
    doc.remove_namespaces!
    doc.css("komiteer_liste > komite").map { |node| new node }
  end

  def initialize(node)
    @node = node
  end

  def id
    @node.css("id").text
  end

  def name
    @node.css("navn").text
  end

end