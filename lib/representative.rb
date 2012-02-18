class Representative
  def self.from_xml(path)
    doc = Nokogiri::XML.parse(File.read(path))
    doc.css("dagensrepresentant").map { |node| new node }
  end

  def initialize(node)
    @node = node
  end

  def name
    "#{first_name} #{last_name}"
  end

  def first_name
    @node.css("fornavn").first.text
  end

  def last_name
    @node.css("etternavn").first.text
  end

  def county
    @node.css("fylke").first.css("navn").text
  end

  def party
    @node.css("parti").first.css("navn").text
  end

  def committees
    @node.css("komite").map { |e| e.css("id").text }.join(", ")
  end

  def deputy_for
    node = @node.css("fast_vara_for")
    if node.children.size > 0
      Representative.new(node)
    end
  end

end