class MetaDataWithContextKeyComposer
  def self.compose_array_for(kontext)
    arr = []
    kontext.context_keys.each do |ck|
      meta_key = ck.meta_key
      meta_data = { meta_data: meta_key.meta_data }
      arr << {}.merge(meta_data).merge(context_key: ck)
    end
    arr
  end
end
