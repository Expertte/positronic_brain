module PositronicBrain
  module Classifier
    class NaiveBayes < PositronicBrain::Classifier::Base
      def classify(item, options={})
        best_category = options[:default] || @default_category
        best_score    = options[:minimum] || @minimum_score || 0.0

        scores = scores item

        scores.each do |category, score|
          if score > best_score
            best_category = category
            best_score    = score
          end
        end

        [best_category, best_score]
      end

      def bayes_scores(item)
        categories.map do |category|
          score = bayes_score item, category
          [category, score]
        end
      end
      alias :scores :bayes_scores

      def bayes_score(item, category)
        item_given_category_product(item, category, weighted: true)*prob_category(category)
      end
      alias :score :bayes_score

    end
  end
end