module StorageMatcher
  def be_stored(expected)
    BeStored.new expected
  end

  def clean_storage
    FileUtils.rm_rf PositronicBrain::Base.dump_path
  end

  class BeStored
    def initialize(expected_path)
      @expected_path = expected_path
    end

    def matches?(target)
      @target = target
      if File.exists?(@target.dump_path)
        @persited = true

        persistence = @target.class.initialize_persistence expected_full_path
        persistence == target.persistence
      else
        false
      end
    end

    def expected_full_path
      File.expand_path File.join(PositronicBrain::Base.dump_path, @expected_path)
    end

    def is_at_message
      if @persited
        "is at #{@target.dump_path}"
      else
        'is nowhere'
      end
    end

    def failure_message
      "expected #{@target.inspect} to be stored at #{@expected_path}, but #{is_at_message}"
    end

    def negative_failure_message
      "expected #{@target.inspect} not to be stored at #{@expected_path}"
    end
  end
end