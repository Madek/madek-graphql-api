# frozen_string_literal: true

describe Types::MediaEntryType do
  context 'type definition' do
    subject { Types::MediaEntryType }

    it "defines 'id' field of NonNull type" do
      check_if_field_is_required('id')
    end

    { title: 'String',
      createdAt: 'ISO8601DateTime' }.each do |field, type|
      it "defines a field #{field} of #{type} type" do
        expect(subject).to have_field(field).that_returns(type(type))
      end
    end
  end
end
