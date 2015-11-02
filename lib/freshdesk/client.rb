require 'freshdesk/client/version'
require 'rest_client'
require 'json'

module Freshdesk
  class Client
    attr_reader :subdomain, :email, :password

    DEFAULT_USER_FIELDS = %w(
      name
      job_title
      email
      phone
      mobile
      twitter_id
      company_name
      client_manager
      address
      tag_names
      description
    )

    def initialize(subdomain, email, password)
      @subdomain = subdomain
      @email = email
      @password = password
    end

    def users(options = '')
      paginate('contacts')
    end

    def create_user(user_data, options = '')
      post_request('contacts', user_data, options)
    end

    def update_user(id, user_data, options = '')
      put_request('contacts', id, user_data, options)
    end

    def delete_user(id, options = '')
      delete_request('contacts', id, options)
    end

    def companies(options = '')
      paginate('companies')
    end

    def user_fields(options = '')
      response = get_request('admin/contact_fields', options)
      JSON.parse(response)
    end

    def custom_fields
      user_fields.each_with_object([]) do |field, memo|
        label = field['contact_field']['name']
        memo << label unless DEFAULT_USER_FIELDS.include?(label)
      end
    end

    private

    def generate_resource(endpoint, options)
      url = "https://#{@subdomain}.freshdesk.com/#{endpoint}.json?#{options}"
      RestClient::Resource.new(url, @email, @password)
    end

    def get_request(resource, options)
      site = generate_resource("#{resource}", options)
      site.get(accept: 'application/json')
    rescue => e
      raise FreshdeskError, e.response
    end

    def paginate(resource)
      page = 1
      all_data = []
      loop do
        response = get_request(resource, "page=#{page}")
        data = JSON.parse(response)
        break if data.blank?

        data.map do |hash|
          if resource == 'contacts'
            all_data << hash['user']
          else
            all_data << hash[resource.singularize]
          end
        end
        page += 1
      end

      all_data
    end

    def post_request(resource, user_data, options)
      site = generate_resource("#{resource}", options)
      site.post(
        {
          user: user_data,
          content_type: 'application/json'
        }
      )
    rescue => e
      raise FreshdeskError, e.response
    end

    def put_request(resource, id, user_data, options)
      site = generate_resource("#{resource}/#{id}", options)
      site.put(
        {
          user: user_data,
          content_type: 'application/json'
        }
      )
    rescue => e
      raise FreshdeskError, e.response
    end

    def delete_request(resource, id, options)
      site = generate_resource("#{resource}/#{id}", options)
      site.delete(accept: 'application/json')
    rescue => e
      raise FreshdeskError, e.response
    end
  end

  FreshdeskError = Class.new(StandardError)
end
