class GraphqlController < ApplicationController
  def execute
    # NOTE: basic validations, raises user errors
    begin
      variables = ensure_hash(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      if !query.present?
        raise GraphQL::ExecutionError, 'No `query` parameter given!'
      end
      parsed_query = GraphQL.parse(query)
      ensure_operations_match_http_method(request, parsed_query)
    rescue => e
      return handle_top_level_error(e, 400)
    end

    # Query context goes here, for example:
    # { current_user: current_user }
    context = {}

    result =
      MadekGraphqlSchema.execute(
        document: parsed_query,
        variables: variables,
        context: context,
        operation_name: operation_name
      )
    render json: result
  rescue => e
    # NOTE: unexpected errors are "internal server error"s
    return handle_top_level_error(e, 500)
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      ambiguous_param.present? ? ensure_hash(JSON.parse(ambiguous_param)) : {}
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def ensure_operations_match_http_method(request, gql_doc)
    doc_has_only_queries =
      gql_doc.definitions.select do |d|
        d.is_a? GraphQL::Language::Nodes::OperationDefinition
      end.all? { |d| d.operation_type === 'query' }

    if request.get? && !doc_has_only_queries
      raise 'When using HTTP `GET`, only `query` operations are allowed. ' \
              'For a `mutation`, use HTTP `POST`.'
    end
  end

  def handle_top_level_error(e, status_code)
    err = e.is_a?(GraphQL::Error) ? e.to_h : { message: e.message }
    err.merge(backtrace: e.backtrace) if Rails.env.development?
    render json: { errors: [err] }, status: status_code
  end
end
