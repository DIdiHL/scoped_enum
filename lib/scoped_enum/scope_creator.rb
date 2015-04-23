module ScopedEnum
  class ScopeCreator
    # Initialize a new ScopeCreator object
    # @param [ActiveRecord]
    # @param [String, Symbol]
    def initialize(record_class, enum_name)
      @record_class = record_class
      @enum_name = enum_name
      @scope_names = []
    end

    # Add a scope of the enum to the class. It creates an instance method - <scope_name>? and a
    # ActiveRecord class scope with the same name as the enum scope.
    # @param [String, Symbol] The name of the enum scope
    # @param [Array<String>, Array<Symbol>] The list of keys of the enum
    def scope(scope_name, scope_enum_keys)
      target_enum = @record_class.defined_enums[@enum_name.to_s]
      sub_enum_values = target_enum.values_at(*scope_enum_keys)

      if @record_class.defined_enum_scopes.has_key?(scope_name)
        fail ArgumentError,
             "Conflicting scope names. A scope named #{scope_name} has already been defined"
      elsif sub_enum_values.include?(nil)
        unknown_key = scope_enum_keys[sub_enum_values.index(nil)]
        fail ArgumentError, "Unknown key - #{unknown_key} for enum #{@enum_name}"
      elsif @record_class.respond_to?(scope_name.to_s.pluralize)
        fail ArgumentError,
             "Scope name - #{scope_name} conflicts with a class method of the same name"
      elsif @record_class.instance_methods.include?("#{scope_name}?".to_sym)
        fail ArgumentError,
             "Scope name - #{scope_name} conflicts with the instance method - #{scope_name}?"
      end

      sub_enum_entries = target_enum.slice(*scope_enum_keys)
      @record_class.defined_enum_scopes[scope_name] = sub_enum_entries

      # 1. Instance method <scope_name>?
      @record_class.send(:define_method, "#{scope_name}?") { sub_enum_entries.include? self.role }

      # 2. The class scope with the scope name
      @record_class.scope scope_name.to_s.pluralize,
                          -> { @record_class.where("#{@enum_name}" => sub_enum_entries.values) }

      @scope_names << scope_name
    end

    # Creates the <enum_name>_scopes class method. It will return a Hash whose keys are the scope
    # names and values are the enum entries under that scope.
    # @returns [HashWithIndifferentAccess] A hash from the scope name to the enum entries under
    # that scope.
    def generate_enum_scopes_method
      scope_names = @scope_names
      @record_class.singleton_class.send(:define_method, "#{@enum_name}_scopes") do
        defined_enum_scopes.slice(*scope_names)
      end
    end
  end
end