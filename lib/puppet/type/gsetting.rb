Puppet::Type.newtype(:gsetting) do
  def self.title_patterns
    [ [ /(.*)/, [ [:key] ] ] ]
  end

  newparam(:schema) do
    isnamevar

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, _("Schema must be a String not %{klass}") % { klass: value.class }
      end
    end
  end

  newparam(:path) do
    isnamevar

    validate do |value|
      if !value.is_a?(String) and !value.nil?
        raise ArgumentError, _("Path must be a String not %{klass}") % { klass: value.class }
      end

      if value !~ %r!^/.+/$!
        raise ArgumentError, "Path must start and end with a '/' character"
      end

      if value =~ %r!//!
        raise ArgumentError, "Path must not contain two consecutive '/' characters"
      end
    end
  end

  newparam(:key) do
    isnamevar

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, _("Key must be a String not %{klass}") % { klass: value.class }
      end
    end
  end

  newparam(:user) do
    isnamevar

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, _("User must be a String not %{klass}") % { klass: value.class }
      end
    end
  end

  newproperty(:value, :array_matching => :all) do
    def insync?(is)
      # puts "insync? #{is} #{@should}"

      # Encapsulate `is` because should= also encapsulates all values in an Array
      super([ is ])
    end

    # def should
    #   puts "should #{@should}"
    #
    #   super
    # end

    # Encapsulate @should values in an Array, because Puppet treats a @should
    # with a 'false' value specially. Required in order to support Boolean
    # values and to differentiate between Strings and Arrays with one element.
    #
    # 'String' becomes [ 'String' ], [ 'ex1', 'ex2' ] becomes [ [ 'ex1', 'ex2'
    # ] ], true becomes [ true ] and false becomes [ false ].
    #
    # The overriden should= method already encapsulates every type except Arrays
    def should=(values)
      # puts "should= #{values}"

      return super([ values ]) if values.is_a?(Array)
      return super
    end

    def should_to_s(value)
      # Decapsulate because should= encapsulates all values in an Array
      super(value.first)
    end

    validate do |value|
      # puts "validate #{value}"

      if [ Array, FalseClass, TrueClass, Integer, String ].none? { |klass| value.is_a?(klass) } then
        raise Puppet::Error, "value should be an Array, Boolean, Integer or String"
      end
    end
  end

  autorequire(:user) do
    [ self[:user] ]
  end
end
