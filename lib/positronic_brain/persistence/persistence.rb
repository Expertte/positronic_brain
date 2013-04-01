module PositronicBrain
  module Persistence
    autoload :Classifier, 'positronic_brain/persistence/classifier/base.rb'

    class Base
      attr_reader :dump_path, :options, :persistence

      def initialize(dump_path, options = {})
        @dump_path, @options = dump_path, options
        load || init
      end

      def dump
        ensure_dump_directory
        File.open(@dump_path, 'w'){ |f| f.puts Marshal.dump @persistence }
      end

      def ==(other)
        @persistence == other.persistence
      end

      protected
      def ensure_dump_directory
        dump_dir = File.dirname @dump_path
        FileUtils.mkdir_p dump_dir unless Dir.exists? dump_dir
      end

      def dumped_data
        File.read @dump_path
      end

      def load
        return false unless File.exists? dump_path
        @persistence = Marshal.load dumped_data
      end

      def init
        @persistence = Hash.new
      end
    end
  end
end