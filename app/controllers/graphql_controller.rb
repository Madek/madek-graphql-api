class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    
    if !query.present?
      raise "No `query` parameter given!"
    end

    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    parsed_query = GraphQL.parse(query)
    ensure_operations_match_http_method(request, parsed_query)
    result = MadekGraphqlSchema.execute(
      document: parsed_query,
      variables: variables,
      context: context,
      operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def ensure_operations_match_http_method(request, gql_doc)
    doc_has_only_queries = gql_doc.definitions
      .select {|d| d.is_a? GraphQL::Language::Nodes::OperationDefinition }
      .all? { |d| d.operation_type === 'query'}

    if request.get? && !doc_has_only_queries
      raise "When using HTTP `GET`, only `query` operations are allowed. " \
            "For a `mutation`, use HTTP `POST`."
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
  end
end
