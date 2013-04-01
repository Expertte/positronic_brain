module PositronicBrain
  module Classifier
    class Fisher < PositronicBrain::Classifier::Base
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

      def fisher_scores(item)
        categories.map do |category|
          score = fisher_score item, category
          [category, score]
        end
      end
      alias :scores :fisher_scores

      def fisher_score(item, category)
        prod = category_given_item_product category, item, weighted: true
        return 0.0 if prod == 0.0

        features_count = extract_features!(item).count
        Distribution::ChiSquare.q_chi2 2*features_count, -2*Math.log(prod)
      end
      alias :score :fisher_score
    end
  end
end