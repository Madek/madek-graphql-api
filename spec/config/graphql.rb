# NOTE: based on <https://github.com/leihs/leihs-procure/blob/6b51ac57c1d7764831c8fad94d05f84b0bf7882e/server/spec/graphql/graphql_helper.rb>
#       but adapted to use request-type rails spec helpers

class GraphqlQuery
  URL = '/graphql'
  HTTP_CLIENT = ActionDispatch::Integration::Session

  attr_reader :response

  def initialize(document, variables = {})
    @document = document.to_s
    @variables = variables.as_json
    @http_client = HTTP_CLIENT.new(Rails.application)
  end

  def perform
    options = {
      headers: {
        'Accept': 'application/json', 'Content-Type': 'application/json'
      },
      params: { query: @document, variables: @variables }.to_json
    }

    @http_client.post(URL, options)
    @response = @http_client.instance_variable_get('@response')
    self
  end

  def result
    JSON.parse(@response.body).deep_symbolize_keys
  end
end

# RSpec.shared_context 'graphql client' do

def graphql_request(document, variables = {})
  GraphqlQuery.new(document, variables).perform
end
# end

# RSpec.configure { |config| config.include_context 'graphql client' }
