module Hdo
  module Import
    class Cli

      def initialize(args)
        type = argv.shift
        @importer = case type
                    when 'representative'
                      Representative
                    when 'party'
                      Party
                    else
                      raise ArgumentError, "invalid type: #{type}"
                    end

        @file = argv.shift or raise ArgumentError, 'no file given'
      end

      def run

      end

      private


    end
  end
end