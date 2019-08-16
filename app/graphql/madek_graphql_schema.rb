require_relative './types/base_enum'

class MadekGraphqlSchema < GraphQL::Schema
  # see https://rmosolgo.github.io/blog/2019/01/29/a-new-runtime-in-graphql-ruby-1-dot-9/
  use GraphQL::Execution::Interpreter
  # use GraphQL::Analysis::AST

  max_depth 25
  middleware(GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 2))

  query(Types::QueryType)
end
