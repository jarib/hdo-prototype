module Hdo
  module Import
    class Party
      FIELDS = [
        Import.external_id_field,
        Field.new(:name, true, :string, 'The name of the party.'),
      ]

      DESC = 'a political party'
      XML_EXAMPLE = <<-XML
<party>
  <externalId>DEM</externalId>
  <name>Democratic Party</name>
</party>
      XML

      def self.import(doc)
        doc.css("party").map do |party|
          ::Party.create(
            :external_id => party.css("externalId").text,
            :name        => party.css("name").text
          )
        end
      end

    end
  end
end
