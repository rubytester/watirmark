module Watirmark
  module Transforms
    def self.new_model model_name, user_defined_name
      model_name = "#{model_name}Model".camelcase
      warn "Overwriting model #{user_defined_name}" if DataModels.has_key?(user_defined_name)
      # Get the reference to the class
      model_class = model_name.split('::').inject(Kernel) {|context, x| context.const_get x}
      model = model_class.new(:model_name => user_defined_name)
      DataModels[user_defined_name] = model
    end
  end
end

# Create a new models and add it to the DataModels hash
NEW_MODEL = Transform /^\[new (\S+) (\S+)\]$/ do |model_name, user_defined_name|
  model_name.chop! if model_name.end_with?(':')
  Watirmark::Transforms.new_model model_name, user_defined_name
end

OLD_STYLE_MODEL = Transform /^\[new ([^:]+): (\S+)\]$/ do |model_name, user_defined_name|
  model_name = model_name.camelcase
  model_name.chop! if model_name.end_with?(':')
  Watirmark::Transforms.new_model model_name, user_defined_name
end

# Return the models from the collection of existing models
MODEL = Transform /^\[(\S+)\]$/ do |model_name|
  DataModels[model_name] ||= Struct.new(:model_name).new(model_name)
end

