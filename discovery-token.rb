# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

CONFIG = File.join(File.dirname(__FILE__), "config.rb")
if File.exist?(CONFIG)
  require CONFIG
end

CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "user-data")
if File.exists?(CLOUD_CONFIG_PATH)
 require 'open-uri'
 require 'yaml'

 token = open($new_discovery_url).read

 data = YAML.load(IO.readlines('user-data')[1..-1].join)
 if data['coreos'].key? 'etcd'
   data['coreos']['etcd']['discovery'] = token
 end
 if data['coreos'].key? 'etcd2'
   data['coreos']['etcd2']['discovery'] = token
 end

 yaml = YAML.dump(data)
 File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end