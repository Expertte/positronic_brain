module PositronicBrain
  module Persistence
    module Classifier
      class Base < PositronicBrain::Persistence::Base
        def feature_count(feature)
          (@persistence[:features][feature] || 0.0).to_f
        end

        def category_count(category)
          (@persistence[:categories][category] || 0.0).to_f
        end

        def feature_in_category_count(feature, category)
          return 0.0 unless @persistence[:features_in_category].has_key?(feature)
          (@persistence[:features_in_category][feature][category] || 0.0).to_f
        end

        def increment_feature(feature, category)
          @persistence[:features_in_category][feature]           ||= Hash.new
          @persistence[:features_in_category][feature][category] ||= 0
          @persistence[:features_in_category][feature][category]  += 1

          @persistence[:features][feature]                       ||= 0
          @persistence[:features][feature]                        += 1
        end

        def increment_category(category)
          @persistence[:categories][category] ||= 0
          @persistence[:categories][category] += 1
          @persistence[:total_count]          += 1
        end

        def categories
          @persistence[:categories].keys
        end

        def total_count
          (@persistence[:total_count] || 0.0).to_f
        end

        protected
        def init
          @persistence                        = Hash.new
          @persistence[:features]             = Hash.new
          @persistence[:categories]           = Hash.new
          @persistence[:features_in_category] = Hash.new
          @persistence[:total_count]          = 0
        end
      end
    end
  end
end