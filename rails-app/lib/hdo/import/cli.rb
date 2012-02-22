module Hdo
  module Import
    class Cli

      def initialize(argv)
        type = argv.shift
        @importer = case type
                    when 'representative'
                      Representative
                    when 'party'
                      Party
                    else
                      raise ArgumentError, "invalid type: #{type.inspect}"
                    end

        @file = argv.shift or raise ArgumentError, 'no file given'
      end

      def run

      end

      private


    end
  end
end