#
#  WORK
#  IN
#  PROGRESS
#

describe 'MediaEntry Metadata', type: :request do
  let(:the_entry) do
    # TODO: entry with title, copyright, license, keyword, author
    entry = create(:media_entry)
    create(:meta_datum_title, media_entry: entry)
    create(:meta_datum_text_date, media_entry: entry)
    create(:meta_datum_people, media_entry: entry)
    create(:meta_datum_keywords, media_entry: entry)
    create(:meta_datum_json, media_entry: entry)
    entry
  end
  let(:vars) { { entryId: the_entry.id } }

  example 'query id' do
    doc = <<-'GRAPHQL'
      query($entryId: ID!) {
        mediaEntry(id: $entryId) {
          id
        }
      }
    GRAPHQL

    expect(graphql_request(doc, vars).result).to eq(
      data: { mediaEntry: { id: the_entry.id } }
    )
  end

  example 'query all Metadata' do
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
    result_md_values = result_md.map { |r| r[:values].map(&:values) }.flatten
    expect(result[:errors]).to be_nil
    expect(result[:data][:mediaEntry][:id]).to eq the_entry.id
    expect(result_md.count).to be 5

    md.where(type: 'MetaDatum::Text').each do |md|
      expect(result_md_values).to include md.string
    end

    md.where(type: 'MetaDatum::TextDate').each do |md|
      expect(result_md_values).to include md.string
    end

    md.where(type: 'MetaDatum::People').map(&:people).flatten.each do |prs|
      expect(result_md_values).to include prs.to_s
    end

    md.where(type: 'MetaDatum::Keywords').map(&:keywords).flatten.each do |kw|
      expect(result_md_values).to include kw.term
    end

    md.where(type: 'MetaDatum::JSON').each do |json|
      expect(result_md_values).to include json.value
    end
  end
end
