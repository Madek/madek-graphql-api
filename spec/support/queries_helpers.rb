module QueriesHelpers
  def media_entry_query
    "query getMediaEntry($id: ID!) {
       mediaEntry(id: $id) {
         id
         createdAt
         title
       }
     }"
  end

  def media_entries_query(first: nil, order_by: nil)
    first = "first: #{first}" if first
    order_by = "orderBy: #{order_by}" if order_by
    params = [first, order_by].join(', ')

    <<-GRAPHQL
      {
        allMediaEntries(#{params}) {
          id
          createdAt
          title
        }
      }
    GRAPHQL
  end

  class CollectionQuery
    def initialize(depth = 0)
      @depth = depth
    end

    def query
      "query getSet($id: ID!,
                           $first: Int,
                           $cursor: String,
                           $orderBy: OrderByEnum,
                           $mediaEntriesMediaTypes: [MediaEntryMediaTypesEnum!]!,
                           $previewsMediaTypes: [PreviewsMediaTypesEnum!]!) {
        set(id: $id) {
          #{subqueries}
        }
      }"
    end

    def subqueries
      "#{collection_attributes}
       #{child_media_entries}
       #{collections if @depth > 0}"
    end

    def collection_attributes
      "id
       url
       metaData {
         edges {
           node {
             id
             metaKey {
               id
             }
             values {
               string
             }
           }
         }
       }"
    end

    def child_media_entries
      "childMediaEntries(first: $first,
                         after: $cursor,
                         orderBy: $orderBy,
                         mediaTypes: $mediaEntriesMediaTypes) {
         pageInfo {
           endCursor
           startCursor
           hasPreviousPage
           hasNextPage
         }
         edges {
           cursor
           node {
             id
             url
             metaData {
               edges {
                 node {
                   id
                   metaKey {
                     id
                   }
                   values {
                     string
                   }
                 }
               }
             }
             mediaFile {
               previews(mediaTypes: $previewsMediaTypes) {
                 edges {
                   node {
                     id
                     url
                     contentType
                     mediaType
                     sizeClass
                   }
                 }
               }
             }
           }
         }
       }"
    end

    def collections
      "sets(first: $first, after: $cursor, orderBy: $orderBy) {
        pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
        }
        edges {
          node {
            #{CollectionQuery.new(@depth - 1).subqueries}
          }
        }
      }"
    end
  end
end
