# vim: set fdm=marker fmr=▶,◀:
# vim: set expandtab shiftwidth=2 softtabstop=2:

Puppet::Type.newtype(:gsetting) do #▶
  def self.title_patterns #▶
    [ [ /^(.+)[.](.+)$/, [ [:schema], [:key] ] ] ]
  end #◀

  newparam(:schema) do #▶
    isnamevar

    validate do |value|
      if value.class != String
        raise Puppet::Error, 'schema should be a String'
      end
    end
  end #◀

  newparam(:key) do #▶
    isnamevar

    validate do |value|
      if value.class != String
        raise Puppet::Error, 'key should be a String'
      end
    end
  end #◀

  newproperty(:value, :array_matching => :all) do #▶
    validate do |value|
      unless [String, FalseClass, TrueClass].include?(value.class)
        raise Puppet::Error, "value should be a String, Boolean or Array of Strings"
      end
    end
  end #◀
end #◀
