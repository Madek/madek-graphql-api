# frozen_string_literal: true

desc 'Dump GraphQL schema to file'
task dump_graphql_schema: :environment do
  schema_path = 'app/graphql/schema.graphql'
  schema_defn = MadekGraphqlSchema.to_definition
  File.write(Rails.root.join(schema_path), schema_defn)
  puts "Updated #{schema_path}"
end
