require "scoped_enum/version"
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

      target_enum = defined_enums[enum_name.to_s]
      scopes.each do |scope_name, scope_enum_keys|
        sub_enum_values = target_enum.values_at(*scope_enum_keys)
        if defined_enum_scopes.has_key?(scope_name)
          fail ArgumentError,
               "Conflicting scope names. A scope named #{scope_name} has already been defined"
        elsif sub_enum_values.include?(nil)
          unknown_key = scope_enum_keys[sub_enum_values.index(nil)]
          fail ArgumentError, "Unknown key - #{unknown_key} for enum #{enum_name}"
        elsif respond_to?(scope_name.to_s.pluralize)
          fail ArgumentError,
               "Scope name - #{scope_name} conflicts with a class method of the same name"
        elsif instance_methods.include?("#{scope_name}?".to_sym)
          fail ArgumentError,
               "Scope name - #{scope_name} conflicts with the instance method - #{scope_name}?"
        end

        sub_enum_entries = target_enum.slice(*scope_enum_keys)
        defined_enum_scopes[scope_name] = sub_enum_entries

        # 1. Instance method <scope_name>?
        define_method("#{scope_name}?") do
          sub_enum_entries.include? self.role
        end

        # 2. The class scope with the scope name
        scope scope_name.to_s.pluralize, -> { where("#{enum_name}" => sub_enum_entries.values) }
      end
      # 3. The class method to return all scopes of the enum
      singleton_class.send(:define_method, "#{enum_name}_scopes") { defined_enum_scopes.slice(*scopes.keys) }
    end
  end
end

ActiveRecord::Base.send(:include, ScopedEnum)
