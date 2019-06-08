# vim: set expandtab shiftwidth=2 softtabstop=2:
require 'gio2' if Puppet.features.gio2?

Puppet::Type.type(:gsetting).provide(:gsetting) do
  confine :feature => :gio2

  def value
    settings = Gio::Settings::new(resource[:schema])

    return settings.get_value(resource[:key])
  end

  def value=(value)
    settings = Gio::Settings::new(resource[:schema])

    # puts "value= #{value}"

    # Decapsulate because should= encapsulates all values in an Array
    value = value.first

    if value.is_a?(Array) then
      settings.set_strv(resource[:key], value)
    elsif value.is_a?(FalseClass)
      settings.set_boolean(resource[:key], value)
    elsif value.is_a?(String)
      settings.set_string(resource[:key], value)
    elsif value.is_a?(TrueClass)
      settings.set_boolean(resource[:key], value)
    end
  end
end
