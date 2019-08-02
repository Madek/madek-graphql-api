# frozen_string_literal: true

class Types::PreviewSizeClassesEnum < Types::BaseEnum
  graphql_name 'PreviewSizeClassesEnum'
  description 'Preview size class'

  description 'Preview size class'
  value 'SMALL', value: 'small'
  value 'SMALL_125', value: 'small_125'
  value 'MEDIUM', value: 'medium'
  value 'LARGE', value: 'large'
  value 'X_LARGE', value: 'x_large'
  value 'MAXIMUM', value: 'maximum'
end
