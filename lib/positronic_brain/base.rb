module PositronicBrain
  class Base
    attr_reader   :namespace
    attr_accessor :persistence

    delegate :dump, to: :persistence

    def initialize(namespace, options = {})
      @namespace   = namespace
      @persistence = self.class.initialize_persistence(dump_path, options[:persistence] || {})
    end

    def dump_path
      path_parts = [self.class.dump_path, self.class.dump_name, "#{@namespace}.marshal"].compact
      File.join *path_parts
    end

    def inspect
      "#<#{self.class.name} #{namespace}>"
    end

    class << self
      attr_writer :dump_path, :dump_name

      def dump_name
        @dump_name || self.name.gsub(/^.*\:\:/, '').underscore
      end

      def dump_path
        @dump_path || self.superclass.dump_path
      end

      def persistence_class
        @persistence_class || self.superclass.persistence_class
      end

      def persistence_options
        @persistence_options || self.superclass.persistence_options
      end

      def persistence(klass, options = {})
        @persistence_class, @persistence_options = klass, options
      end

      def initialize_persistence(path, options = {})
        persistence_class.new path, persistence_options.merge(options)
      end
    end
  end
end