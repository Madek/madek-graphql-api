module TypesHelpers
  def type(type)
    "GraphQL::Types::#{type}"
  end

  def check_if_field_is_required(field)
    expect(subject.fields[field].type)
      .to be_instance_of(GraphQL::Schema::NonNull)
  end
end
