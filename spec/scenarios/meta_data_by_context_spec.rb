describe 'querying Metadata by Context', type: :request do
  let(:context_key_0) { create(:context_key) }
  let(:context_key_1) { create(:context_key) }
  let(:context_key_2) { create(:context_key) }
  let(:context_0) { context_key_0.context }
  let(:context_1) { context_key_1.context }
  let(:context_2) { context_key_2.context }
  let(:meta_datum_0) { create(:meta_datum_title, meta_key: context_key_0.meta_key) }
  let(:meta_datum_1) { create(:meta_datum_title, meta_key: context_key_1.meta_key) }
  let(:meta_datum_2) { create(:meta_datum_title, meta_key: context_key_2.meta_key) }

  before(:each) { set_meta_datum_and_contexts }

  def set_meta_datum_and_contexts
    meta_datum_0
    meta_datum_1
    meta_datum_2
  end

  q = <<-'GRAPHQL'
    query($contexts: [String!]!) {
      metaDataByContext(contexts: $contexts) {
        id
        label
        metaData {
           edges {
             node {
              metaDatum {
                id
              }
              contextKey {
                id
                position
                label
                description
                metaKey {
                  id
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL

  it 'returns MetaData for all contexts if no context specified' do
    vars = { contexts: [] }
    contexts = [context_0, context_1, context_2]

    md_by_context = graphql_request(q, vars).result[:data][:metaDataByContext]
    verify_meta_data_by_context_result(md_by_context,
                                       [context_0, context_1, context_2])
  end

  it 'returns MetaData for specified contexts' do
    contexts = [context_0, context_1].map(&:id)
    vars = { contexts: contexts }

    md_by_context = graphql_request(q, vars).result[:data][:metaDataByContext]
    verify_meta_data_by_context_result(md_by_context, [context_0, context_1])
  end

  def verify_meta_data_by_context_result(result, contexts)
    contexts.each_with_index do |c, i|
      kontext = result.find { |k| k[:id] == c.id }
      expect(kontext).to be
      expect(kontext[:label]).to eq(c.labels[Settings[:madek_default_locale]])

      kontext_meta_data_node = kontext[:metaData][:edges][0][:node]
      expect(kontext_meta_data_node[:metaDatum].map(&:values).flatten)
        .to include(send("meta_datum_#{i}").id)

      context_key = kontext_meta_data_node[:contextKey]
      expect(context_key[:id]).to eq(send("context_key_#{i}").id)
    end
  end
end
