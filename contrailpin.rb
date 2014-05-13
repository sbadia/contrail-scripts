#!/usr/bin/env ruby
#
# A simple script to fetch latest contrail sha and generate a yml conf
# Copyright (C) 2014  Sebastien Badia <sebastien.badia@enovance.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# On Debian systems: apt-get install ruby-json ruby-nokogiri ruby-rest-client
require 'json'
require 'nokogiri'
require 'rest_client'
require 'yaml'

Proto = 'https'
Ghapi = 'api.github.com'
Owner = 'Juniper'

# Timestamp au format ISO 8601 (2014-04-22T00:00:00Z)
# 2014-04-22
date = ENV['DATE'] ? ENV['DATE'] : (Time.now.strftime "%Y-%m-%d")

# Contrail VNC file (for repo)
# https://github.com/Juniper/contrail-vnc
vnc = ENV['VNC'] || './noauth.xml'

# YAML vnc configuration file (with sha)
yml_conf = ENV['YML']

# Refs objects https://developer.github.com/v3/git/refs/
# refs/heads/R1.06
# refs/tags/v1.06
refs = ENV['REF'] ? "heads/R#{ENV['REF']}" : 'heads/master'

pconf = {}
nok = Nokogiri::XML(File.open(vnc))

if yml_conf
  yml = YAML.load_file(yml_conf)
else
  nok.root.xpath('//project').each do |p|
    if date != (Time.now.strftime "%Y-%m-%d")
      a = JSON.load(RestClient.get "#{Proto}://#{Ghapi}/repos/#{Owner}/#{p['name']}/commits?until=#{date}T00:00:00Z&page=1&per_page=1")
      sha = a[0]['sha']
      pconf = pconf.merge({"#{p['name']}" => "#{sha}"})
    else
      begin
        res = RestClient.get "#{Proto}://#{Ghapi}/repos/#{Owner}/#{p['name']}/git/refs/#{refs}"
      rescue
        res = RestClient.get "#{Proto}://#{Ghapi}/repos/#{Owner}/#{p['name']}/git/refs/heads/master"
      end
      sha = JSON.load(res)['object']['sha']
      pconf = pconf.merge({"#{p['name']}" => "#{sha}"})
    end
    puts "Projet: #{p['name']} => sha: #{sha}"
  end
  yml = YAML.load(pconf.to_yaml)
  File.open("/tmp/contrail_#{date}.yml", 'w') {|f| f.write pconf.to_yaml }
end

nok.root.xpath('//project').each do |p|
  p['revision'] = yml[p['name']]
end

manifest = File.open('/tmp/manifest.xml', 'w')
nok.write_xml_to(manifest)
manifest.close
