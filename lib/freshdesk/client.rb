require "freshdesk/client/version"
require "rest_client"
require "json"

module Freshdesk
  class Client
    attr_reader :freshdesk_name, :email, :password

    DEFAULT_USER_FIELDS = [
       "Full Name",
       "Title",
       "Email",
       "Work Phone",
       "Mobile Phone",
       "Twitter",
       "Company",
       "Can see all tickets from this company",
       "Address",
       "Time Zone",
       "Language",
       "Tags",
       "Background information",
    ]

    def initialize(freshdesk_name, email, password)
      @freshdesk_name = freshdesk_name
      @email = email
      @password = password
    end

    def users(options = "")
      response = get_request('contacts', options)
      users = JSON.parse(response)
      users.map do |user|
        user['user']
      end
    end

    def create_user(user_data, options = "")
      post_request('contacts', user_data, options)
    end

    def update_user(id, user_data, options = "")
      put_request('contacts', id, user_data, options)
    end

    def delete_user(id, options = "")
      delete_request('contacts', id, options)
    end

    def companies(options = "")
      response = get_request('companies', options)
      companies = JSON.parse(response)
      companies.map do |company|
        company['company']
      end
    end

    def user_fields(options = "")
      response = get_request('admin/contact_fields', options)
      fields = JSON.parse(response)
    end

    def custom_fields
      user_fields.each_with_object([]) do |field, memo|
        label = field['contact_field']['label']
        memo << label if !DEFAULT_USER_FIELDS.include?(label)
      end
    end

    private

    def generate_resource(endpoint)
      api_url = "https://#{@freshdesk_name}.freshdesk.com/#{endpoint}.json"
      RestClient::Resource.new(api_url, @email, @password)
    end

    def get_request(resource, options)
      site = generate_resource("#{resource}")
      site.get(:accept=>"application/json")
    end

    def post_request(resource, user_data, options)
      site = generate_resource("#{resource}")
      site.post({
        :user => user_data,
        :content_type => "application/json"
      })
    end

    def put_request(resource, id, user_data, options)
      site = generate_resource("#{resource}/#{id}")
      site.put({
        :user=> user_data,
        :content_type=>"application/json"
      })
    end

    def delete_request(resource, id, options)
      site = RestClient::Resource.new("https://#{@freshdesk_name}.freshdesk.com/#{resource}/#{id}.json", @email, @password)
      site.delete(:accept=>"application/json")
    end

  end
end
