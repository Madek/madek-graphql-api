#
#  WORK
#  IN
#  PROGRESS
#

describe 'MediaEntry Metadata', type: :request do
  let(:the_entry) do
    # TODO: entry with title, copyright, license, keyword, author
    entry = FactoryGirl.create(:media_entry)
    FactoryGirl.create(:meta_datum_title, media_entry: entry)
    FactoryGirl.create(:meta_datum_text_date, media_entry: entry)
    FactoryGirl.create(:meta_datum_people, media_entry: entry)
    FactoryGirl.create(:meta_datum_keywords, media_entry: entry)
    entry
  end

  example 'query id' do
    vars = { entryId: the_entry.id }
    doc = <<-'GRAPHQL'
      query($entryId: ID!) {
        mediaEntry(id: $entryId) {
          id

        }
      }
    GRAPHQL

    expect(graphql_request(doc, vars).result).to eq(
      { data: { mediaEntry: { id: the_entry.id } } }
    )
  end

  example 'query all Metadata', pending: 'FIX STRING VALUES' do
    vars = { entryId: the_entry.id }
    doc = <<-'GRAPHQL'
      query($entryId: ID!) {
        mediaEntry(id: $entryId) {
          id
          metaData {
            nodes {
              metaKey {
                id
              }
              values {
                string
              }
            }
          }
        }
      }
    GRAPHQL

    result = graphql_request(doc, vars).result
    md = the_entry.meta_data
    result_md = result[:data][:mediaEntry][:metaData][:nodes]

    expect(result[:errors]).to be_nil
    expect(result[:data][:mediaEntry][:id]).to eq the_entry.id
    expect(result_md.count).to be 4

    md.where(type: 'MetaDatum::Text').each do |md|
      expect(result_md).to include md.string
    end

    md.where(type: 'MetaDatum::TextDate').each do |md|
      expect(result_md).to include md.string
    end

    md.where(type: 'MetaDatum::People').map(&:people).flatten.each do |prs|
      expect(result_md).to include prs.to_s
    end

    md.where(type: 'MetaDatum::Keywords').map(&:keywords).flatten.each do |kw|
      expect(result_md).to include kw.term
    end
  end
end
