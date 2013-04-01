gem_root = File.dirname __FILE__
$LOAD_PATH.unshift(gem_root) unless $LOAD_PATH.include?(gem_root)

require 'fileutils'

require 'active_support'
require 'active_support/core_ext'

require 'distribution'

module PositronicBrain
  autoload :VERSION,     'positronic_brain/version.rb'
  autoload :Base,        'positronic_brain/base.rb'

  autoload :Classifier,  'positronic_brain/classifier/classifier.rb'
  autoload :Persistence, 'positronic_brain/persistence/persistence.rb'
end
