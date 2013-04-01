# encoding: utf-8
require 'spec_helper'

module PositronicBrain::Classifier
  describe NaiveBayes do
    describe 'perform probabilities calculations' do
      context 'unweighted_classifier' do
        before(:all) do
          $classifier = NaiveBayes.new 'unweighted_classifier', assumed_probability: 0.0, assumed_weight: 0.0
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should calculate scores' do
          subject.score('quick rabbit', :good).should be_within(0.001).of(0.1333)
          subject.score('quick rabbit', :bad ).should be_within(0.001).of(0.0   )
        end

      end

      context 'weighted_classifier' do
        before(:all) do
          $classifier = NaiveBayes.new 'weighted_classifier'
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should have category probabilities' do
          subject.score('quick rabbit', :good).should be_within(0.001).of(0.156249)
          subject.score('quick rabbit', :bad ).should be_within(0.001).of(0.050000)
        end

      end
    end

    describe 'perform persistence operations' do
      context 'classifier' do
        before(:all) do
          $classifier = NaiveBayes.new 'some_classifier'
          TRAIN_BASE.each{ |item, category| $classifier.train item, category }
        end

        before(:each){ clean_storage }
        after(:each){  clean_storage }

        after(:all){ $classifier = nil }

        subject{ $classifier }

        it 'should have able to be stored' do
          subject.should_not be_stored('naive_bayes/some_classifier.marshal')
          subject.dump
          subject.should be_stored('naive_bayes/some_classifier.marshal')
        end
      end
    end
  end
end