class Types::OrderByEnum < Types::BaseEnum
  graphql_name 'OrderByEnum'
  description 'Paremeter for ordering resources'

  value 'CREATED_AT_DESC', value: 'created_at DESC'
  value 'CREATED_AT_ASC', value: 'created_at ASC'
end
