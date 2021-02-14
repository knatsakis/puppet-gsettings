require 'gio2' if Puppet.features.gio2?
require 'etc'

Puppet::Type.type(:gsetting).provide(:gsetting) do
  confine :feature => :gio2

  def value
    uid = Etc.getpwnam(resource[:user]).uid

    reader, writer = IO.pipe

    fork do
      reader.close

      ENV.clear
      ENV['DBUS_SESSION_BUS_ADDRESS'] = "unix:path=/run/user/#{uid}/bus"

      Process::Sys.setuid(uid)

      if resource[:path].nil?
        settings = Gio::Settings::new(resource[:schema])
      else
        settings = Gio::Settings::new(resource[:schema], options = { path: resource[:path] })
      end

      writer.write(Marshal.dump(settings.get_value(resource[:key])))
    end

    writer.close

    return Marshal.load(reader.gets(nil))
  end

  def value=(value)
    uid = Etc.getpwnam(resource[:user]).uid

    reader, writer = IO.pipe

    fork do
      reader.close

      ENV.clear
      ENV['DBUS_SESSION_BUS_ADDRESS'] = "unix:path=/run/user/#{uid}/bus"

      Process::Sys.setuid(uid)

      if resource[:path].nil?
        settings = Gio::Settings::new(resource[:schema])
      else
        settings = Gio::Settings::new(resource[:schema], options = { path: resource[:path] })
      end

      # Decapsulate because should= encapsulates all values in an Array
      settings.set_value(resource[:key], value.first)
    end

    writer.close
  end
end
