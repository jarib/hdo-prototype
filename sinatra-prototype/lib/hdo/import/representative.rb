module HDO
  module Import

    class Representative
      def self.from_xml(path)
        doc = Nokogiri::XML.parse(File.read(path))
        doc.remove_namespaces!
        doc.css("dagensrepresentant").map { |node| new node }
      end

      def initialize(node)
        @node = node
      end

      def name
        "#{last_name}, #{first_name}"
      end

      def first_name
        @node.xpath("./fornavn").text
      end

      def last_name
        @node.xpath("./etternavn").first.text
      end

      def county
        @node.xpath("./fylke/navn").text
      end

      def party
        @node.xpath("./parti").first.css("navn").text
      end

      def committees
        @node.css("komite").map { |e| e.css("id").text }
      end

      def deputy_for
        node = @node.xpath("./fast_vara_for")
        if node.children.size > 0
          Representative.new(node)
        end
      end
    end

  end
end