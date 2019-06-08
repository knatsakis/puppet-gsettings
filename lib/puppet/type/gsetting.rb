# vim: set expandtab shiftwidth=2 softtabstop=2:
Puppet::Type.newtype(:gsetting) do
  def self.title_patterns
    [ [ /^(.+)[.](.+)$/, [ [:schema], [:key] ] ] ]
  end

  newparam(:schema) do
    isnamevar

    validate do |value|
      raise Puppet::Error, 'schema should be a String' unless value.is_a?(String)
    end
  end

  newparam(:key) do
    isnamevar

    validate do |value|
      raise Puppet::Error, 'key should be a String' unless value.is_a?(String)
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

      if [ Array, FalseClass, String, TrueClass ].none? { |klass| value.is_a?(klass) } then
        raise Puppet::Error, "value should be an Array, Boolean or String"
      end
    end
  end
end
