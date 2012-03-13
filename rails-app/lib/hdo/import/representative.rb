module Hdo
  module Import
    class Representative
      FIELDS = [
        Import.external_id_field,
        Field.new(:firstName, true, :string, 'The first name of the representative.'),
        Field.new(:lastName, true, :string, 'The last name of the representative.'),
        Field.new(:period, true, :string, "An identifier for the period the representative is elected for."),
        Field.new(:area, true, :string, 'The geographical area the representative belongs to.'),
        Field.new(:party, true, :string, "The name of the representative's party."),
        Field.new(:committee, true, :list, "A list of committees the representative is a member of."),
      ]

      DESC = 'a member of parliament'
      XML_EXAMPLE = <<-XML
<representative>
  <externalId>DD</externalId>
  <firstName>Donald</firstName>
  <lastName>Duck</lastName>
  <area>Duckburg</area>
  <party>Democratic Party</party>
  <committees>
    <committe>A</committe>
    <committe>B</committe>
  </committes>
  <period>2011-2012</period>
</representative>
      XML

      def self.import(doc)
        doc.css("representative").map do |rep|
          party = ::Party.find_by_name rep.css("party").text

          ::Representative.create(
            :external_id => rep.css("externalId").first.text,
            :first_name  => rep.css("firstName").first.text,
            :last_name   => rep.css("lastName").first.text,
            # :area        => rep.css("area").text,
            :party       => party
          )
        end
      end

    end
  end
end
