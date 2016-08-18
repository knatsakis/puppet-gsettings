# vim: set fdm=marker fmr=▶,◀:
# vim: set expandtab shiftwidth=2 softtabstop=2:

require 'gio2' if Puppet.features.gio2?

Puppet::Type.type(:gsetting).provide(:gsetting) do #▶
  confine :feature => :gio2

  def value #▶
    settings = Gio::Settings::new(resource[:schema])

    return [ settings.get_value(resource[:key]) ].flatten
  end #◀

  def value=(value) #▶
    settings = Gio::Settings::new(resource[:schema])

    if resource[:value].size != 1
      settings.set_strv(resource[:key], resource[:value])
    else
      if resource[:value].class == String
        settings.set_string(resource[:key], resource[:value].first)
      else
        settings.set_boolean(resource[:key], resource[:value].first)
      end
    end
  end #◀
end #◀
