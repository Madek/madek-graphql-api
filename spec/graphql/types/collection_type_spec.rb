describe Types::CollectionType do
  context 'type definition' do
    subject { Types::CollectionType }

    it "defines 'id' field of NonNull type" do
      check_if_field_is_required('id')
    end

    { getMetadataAndPreviews: 'Boolean',
      createdAt: 'ISO8601DateTime',
      updatedAt: 'ISO8601DateTime',
      layout: 'String',
      sorting: 'String',
      responsibleUserId: 'String' }.each do |field, type|
      it "defines a field #{field} of #{type} type" do
        expect(subject).to have_field(field).that_returns(type(type))
      end
    end

    %w[childMediaEntries sets metaData].each do |connection|
      it "defines a field #{connection} that is a connection type" do
        expect(subject.fields[connection].connection?).to be(true)
      end
    end
  end
end
