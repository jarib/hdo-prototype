module HDO
  module Import

    class Party
      def self.from_xml(path)
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

  end
end
