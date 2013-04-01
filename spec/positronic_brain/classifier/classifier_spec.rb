# encoding: utf-8
require 'spec_helper'

module PositronicBrain::Classifier
  describe Base do
    describe 'perform probabilities calculations' do
      context 'unweighted_classifier' do
        before(:all) do
          $classifier = Base.new 'unweighted_classifier', assumed_probability: 0.0, assumed_weight: 0.0
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should have category probabilities' do
          subject.prob_category(:good).should be_within(0.001).of(0.6)
          subject.prob_category(:bad ).should be_within(0.001).of(0.4)
        end

        it 'should have zero category given feature probabilities for missing word' do
          subject.prob_category_given_feature(:good, 'bazinga').should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'bazinga').should be_within(0.001).of(0.0)
        end

        it 'should have zero category given feature weighted probabilities for missing word' do
          subject.prob_category_given_feature(:good, 'bazinga', weighted: true).should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'bazinga', weighted: true).should be_within(0.001).of(0.0)
        end

        it 'should have category given feature probabilities for matched word' do
          subject.prob_category_given_feature(:good, 'quick').should be_within(0.001).of(0.666)
          subject.prob_category_given_feature(:bad,  'quick').should be_within(0.001).of(0.333)
        end

        it 'should have category given feature weighted probabilities for matched word' do
          subject.prob_category_given_feature(:good, 'quick', weighted: true).should be_within(0.001).of(0.666)
          subject.prob_category_given_feature(:bad,  'quick', weighted: true).should be_within(0.001).of(0.333)
        end

        it 'should have category given feature probabilities for only good matched word' do
          subject.prob_category_given_feature(:good, 'rabbit').should be_within(0.001).of(1.0)
          subject.prob_category_given_feature(:bad,  'rabbit').should be_within(0.001).of(0.0)
        end

        it 'should have category given feature weighted probabilities for only good matched word' do
          subject.prob_category_given_feature(:good, 'rabbit', weighted: true).should be_within(0.001).of(1.0)
          subject.prob_category_given_feature(:bad,  'rabbit', weighted: true).should be_within(0.001).of(0.0)
        end

        it 'should have category given feature probabilities for only bad matched word' do
          subject.prob_category_given_feature(:good, 'casino').should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'casino').should be_within(0.001).of(1.0)
        end

        it 'should have category given feature weighted probabilities for only bad matched word' do
          subject.prob_category_given_feature(:good, 'casino', weighted: true).should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'casino', weighted: true).should be_within(0.001).of(1.0)
        end

        it 'should have zero category given item products if has some missing word' do
          subject.category_given_item_product(:good, 'bazinga rabbit casino', weighted: true).should be_within(0.001).of(0.0)
          subject.category_given_item_product(:bad,  'bazinga rabbit casino', weighted: true).should be_within(0.001).of(0.0)
          subject.category_given_item_product(:good, 'bazinga airplane',      weighted: true).should be_within(0.001).of(0.0)
          subject.category_given_item_product(:bad,  'bazinga airplane',      weighted: true).should be_within(0.001).of(0.0)
          subject.category_given_item_product(:good, 'rabbit casino',         weighted: true).should be_within(0.001).of(0.0)
          subject.category_given_item_product(:bad,  'rabbit casino',         weighted: true).should be_within(0.001).of(0.0)
        end

        it 'should have category given item products if has all matched words' do
          subject.category_given_item_product(:good, 'the quick', weighted: true).should be_within(0.001).of(0.3809)
          subject.category_given_item_product(:bad,  'the quick', weighted: true).should be_within(0.001).of(0.1428)
        end
      end

      context 'weighted_classifier' do
        before(:all) do
          $classifier = Base.new 'weighted_classifier'
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should have category probabilities' do
          subject.prob_category(:good).should be_within(0.001).of(0.6)
          subject.prob_category(:bad ).should be_within(0.001).of(0.4)
        end

        it 'should have zero category given feature probabilities for missing word' do
          subject.prob_category_given_feature(:good, 'bazinga').should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'bazinga').should be_within(0.001).of(0.0)
        end

        it 'should have default category given feature weighted probabilities for missing word' do
          subject.prob_category_given_feature(:good, 'bazinga', weighted: true).should be_within(0.001).of(0.5)
          subject.prob_category_given_feature(:bad,  'bazinga', weighted: true).should be_within(0.001).of(0.5)
        end

        it 'should have category given feature probabilities for matched word' do
          subject.prob_category_given_feature(:good, 'quick').should be_within(0.001).of(0.666)
          subject.prob_category_given_feature(:bad,  'quick').should be_within(0.001).of(0.333)
        end

        it 'should have category given feature weighted probabilities for matched word' do
          subject.prob_category_given_feature(:good, 'quick', weighted: true).should be_within(0.001).of(0.6245 )
          subject.prob_category_given_feature(:bad,  'quick', weighted: true).should be_within(0.001).of(0.37475)
        end

        it 'should have category given feature probabilities for only good matched word' do
          subject.prob_category_given_feature(:good, 'rabbit').should be_within(0.001).of(1.0)
          subject.prob_category_given_feature(:bad, 'rabbit' ).should be_within(0.001).of(0.0)
        end

        it 'should have category given feature weighted probabilities for only good matched word' do
          subject.prob_category_given_feature(:good, 'rabbit', weighted: true).should be_within(0.001).of(0.75)
          subject.prob_category_given_feature(:bad,  'rabbit', weighted: true).should be_within(0.001).of(0.25)
        end

        it 'should have category given feature probabilities for only bad matched word' do
          subject.prob_category_given_feature(:good, 'casino').should be_within(0.001).of(0.0)
          subject.prob_category_given_feature(:bad,  'casino').should be_within(0.001).of(1.0)
        end

        it 'should have category given feature weighted probabilities for only bad matched word' do
          subject.prob_category_given_feature(:good, 'casino', weighted: true).should be_within(0.001).of(0.25)
          subject.prob_category_given_feature(:bad,  'casino', weighted: true).should be_within(0.001).of(0.75)
        end

        it 'should use assumed probability avoiding zero category given item products at missing words' do
          subject.category_given_item_product(:good, 'bazinga rabbit casino', weighted: true).should be_within(0.001).of(0.09375)
          subject.category_given_item_product(:bad,  'bazinga rabbit casino', weighted: true).should be_within(0.001).of(0.09375)
          subject.category_given_item_product(:good, 'bazinga airplane',      weighted: true).should be_within(0.001).of(0.25   )
          subject.category_given_item_product(:bad,  'bazinga airplane',      weighted: true).should be_within(0.001).of(0.25   )
          subject.category_given_item_product(:good, 'rabbit casino',         weighted: true).should be_within(0.001).of(0.1875 )
          subject.category_given_item_product(:bad,  'rabbit casino',         weighted: true).should be_within(0.001).of(0.1875 )
        end

        it 'should have category given item products if has all matched words' do
          subject.category_given_item_product(:good, 'the quick', weighted: true).should be_within(0.001).of(0.35059)
          subject.category_given_item_product(:bad,  'the quick', weighted: true).should be_within(0.001).of(0.16369)
        end
      end
    end

    describe 'perform persistence operations' do
      context 'classifier' do
        before(:all) do
          $classifier = Base.new 'some_classifier'
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        before(:each){ clean_storage }
        after(:each){  clean_storage }

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should have able to be stored' do
          subject.should_not be_stored('base/some_classifier.marshal')
          subject.dump
          subject.should be_stored('base/some_classifier.marshal')
        end
      end
    end
  end
end