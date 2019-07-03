desc "Dump GraphQL schema to file"
task dump_graphql_schema: :environment do
  schema_path = "app/graphql/schema.graphql"
  schema_defn = MadekGraphqlSchema.to_definition
  File.write(Rails.root.join(schema_path), schema_defn)
  puts "Updated #{schema_path}"
end

task build_graphql_docs: :environment do
  options = {
    schema: MadekGraphqlSchema.to_definition,
    delete_output: true, # (before building)
    base_url: '/madek-graphql-api/docs', # matches github pages path!
    output_dir: Rails.root.join("./docs"), # symlinked inside /public to match base_url!
  }
  GraphQLDocs.build(options)
  puts "Built docs in #{options[:output_dir]}"
end
