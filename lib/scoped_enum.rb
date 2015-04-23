require 'scoped_enum/version'
require 'scoped_enum/scope_creator'
require 'active_support'
require 'active_record'

module ScopedEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def self.extended(base)
      base.class_attribute(:defined_enum_scopes)
      base.defined_enum_scopes = HashWithIndifferentAccess.new
    end

    def scoped_enum(enum_name, enum_entries, scopes = {})
      enum(enum_name => enum_entries)
      scopes = HashWithIndifferentAccess.new_from_hash_copying_default(scopes)

      scope_creator = ScopeCreator.new(self, enum_name)
      scopes.each do |scope_name, scope_enum_keys|
        scope_creator.scope scope_name, scope_enum_keys
      end

      yield scope_creator if block_given?
      scope_creator.generate_enum_scopes_method
    end
  end
end

ActiveRecord::Base.send(:include, ScopedEnum)
