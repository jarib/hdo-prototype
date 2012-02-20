module HDO
  module Import

    class Issue
      def self.from_xml(path)
        doc = Nokogiri::XML.parse(File.read(path))
        doc.remove_namespaces!
        doc.css("saker_liste > sak").map { |node| new node }
      end

      def initialize(node)
        @node = node
      end

      def topics
        @node.css("emne_liste > emne").map { |e| Topic.new e }
      end

      def id
        @node.xpath("./id").text.to_i
      end

      def short_title
        @node.css("korttittel").first.text
      end

      def title
        @node.css("tittel").first.text
      end

      def last_update
        Time.parse @node.css("sist_oppdatert_dato").first.text
      end

      def type
        @node.css("type").first.text
      end

      def document_group
        @node.css("dokumentgruppe").first.text
      end

      def reference
        @node.css("henvisning").first.text
      end
    end

  end
end
