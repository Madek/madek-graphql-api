#
# WORK
# IN
# PROGRESS
#

describe 'MediaEntry Metadata', type: :request do
  let(:the_entry) { entry = FactoryGirl.create(:media_entry) }

  example 'query all' do
    vars = { entryId: the_entry.id }
    doc = <<-GRAPHQL
      query oneMediaEntryWithAllMetaData($entryId: ID!) {
        mediaEntry(id: $entryId) {
          id
        }
      }
    GRAPHQL

    expect(graphql_request(doc, vars).result).to eq(
      { data: { mediaEntry: { id: the_entry.id } } }
    )
  end
end
