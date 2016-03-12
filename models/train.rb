require 'yaml'
require 'net/https'

module Model
  HOST = 'api.mlab.com'
  PATH = '/api/1/databases/%s/collections/%s'

  def self.included(klass)
    klass.extend ModelBase
  end

  module ModelBase
    def self.config=(file)
      @@conf = YAML.load_file(file)
      @@path = PATH % [@@conf['database'], @@conf['collection']]
    end

    def get
      https_start do |https|
        JSON.parse(https.get(@@path + "?apiKey=#{@@conf['apikey']}").body)
      end
    end

    private
    def https_start
      Net::HTTP.version_1_2
      https = Net::HTTP.new(HOST, 443)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.start { yield https }
    end
  end
end

class Train
  include Model

  def self.search(train_name)
    response = {}
    search_rule = YAML.load_file(File.dirname(__FILE__) + "/../config/search_rule.yml")
    begin
      get[0]["data"].each do |id, map|
        if search_rule[id.to_i].nil?
          unless map["name"].index(train_name).nil?
            return map
          end
        else
          custom_regexp = Regexp.new(search_rule[id.to_i].join("|"))
          if custom_regexp =~ train_name
            return map
          end
        end
      end
    rescue => e
      response = {:error => e.message}
    end

    response
  end

  def self.commute
    response = []
    begin
      commute_rule = YAML.load_file(File.dirname(__FILE__) + "/../config/commute_rule.yml")
      get[0]["data"].each do |id, map|
        if commute_rule.include? id.to_i
          response << map
        end
      end
    rescue => e
      response << {:error => e.message}
    end

    response
  end

end
