module PositronicBrain
  module Classifier
    autoload :Fisher,     'positronic_brain/classifier/fisher.rb'
    autoload :NaiveBayes, 'positronic_brain/classifier/naive_bayes.rb'

    class Base < PositronicBrain::Base
      persistence Persistence::Classifier::Base

      delegate :categories,    :category_count,     to: :persistence
      delegate :total_count,   :increment_feature,  to: :persistence
      delegate :feature_count, :increment_category, to: :persistence
      delegate :feature_in_category_count, :dump,   to: :persistence

      def initialize(namespace, options = {}, &extract_block)
        options = options.dup

        @assumed_probability = options.delete(:assumed_probability) || 0.5
        @default_category    = options.delete(:default_category)
        @minimum_score       = options.delete(:minimum_score)       || 0.0
        @assumed_weight      = options.delete(:assumed_weight)      || 1

        @extract_block = extract_block if block_given?

        super namespace, options
      end

      def extract_features(item)
        item.downcase.split(/\P{Word}+/).uniq
      end

      def classify(item, default = nil)
        raise NotImplementedError
      end

      def train(item, category)
        extract_features!(item).each do |feature|
          increment_feature feature, category
        end
        increment_category category
      end

      def prob_category(category)
        tc = total_count
        return 0.0 if total_count == 0.0

        category_count(category)/tc
      end

      def item_given_category_product(item, category, options={})
        prod  = 1.0
        extract_features!(item).each do |feature|
          prod *= prob_feature_given_category(feature, category, options)
        end
        prod
      end

      def category_given_item_product(category, item, options={})
        prod  = 1.0
        extract_features!(item).each do |feature|
          prod *= normalized_prob_category_given_feature(category, feature, options)
        end
        prod
      end

      def prob_feature_given_category(feature, category, options={})
        cc                  = category_count category
        feature_in_category = feature_in_category_count feature, category

        if options[:weighted]
          fc = feature_count feature
          weighted feature_in_category/cc, fc
        else
          return 0.0 if cc == 0.0
          feature_in_category/cc
        end
      end

      def normalized_prob_category_given_feature(category, feature, options={})
        feature_given_category       = prob_feature_given_category feature, category
        all_feature_given_categories = categories.map do |cat|
          prob_feature_given_category feature, cat
        end.sum

        if options[:weighted]
          fc = feature_count feature
          weighted feature_given_category/all_feature_given_categories, fc
        else
          return 0.0 if fc == 0.0
          feature_given_category/all_feature_given_categories
        end
      end

      def prob_category_given_feature(category, feature, options={})
        fc                  = feature_count feature
        feature_in_category = feature_in_category_count feature, category

        if options[:weighted]
          weighted feature_in_category/fc, fc
        else
          return 0.0 if fc == 0.0
          feature_in_category/fc
        end
      end

      protected
      def weighted(result, weight)
        return @assumed_probability if weight == 0
        (result*weight + @assumed_weight*@assumed_probability)/(weight + @assumed_weight)
      end

      def extract_features!(item)
        if @extract_block
          @extract_block.call item
        else
          extract_features item
        end
      end
    end
  end
end