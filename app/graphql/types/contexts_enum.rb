class Types::ContextsEnum < Types::BaseEnum
  graphql_name 'ContextsEnum'
  description 'Contexts'

  description 'Contexts'

  Context.all.each do |c|
    value c.id.underscore.upcase, value: c.id
  end
end


