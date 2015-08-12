include_recipe "openvpn::common"
include_recipe "openvpn::config_client"
include_recipe "openvpn::autopki"

service "openvpn" do
  action [:enable, :start]
  reload_command "/etc/init.d/openvpn soft-restart"
end

class << self; include OpenvpnHelpers; end

openvpn_process :client_configs do
    config_name = self.conf_name
    config = self.conf
    # user_name required for given vpn server/config
    user_name = config[:user_name]

    service "openvpn@#{config_name}-#{user_name}" do
      action [:enable, :start]
      reload_command "/etc/init.d/openvpn soft-restart"
      only_if { ::File.exists?('/lib/systemd/system/openvpn@.service') }
    end
end
