# API client use case: gallery/slideshow from images in a Madek Set

Goal: A static site generator can render the static html page only using the JSON
data received from the API.

Current State: HTML is written manually.

## description

For a Madek Collection, get Metadata and all the contained MediaEntries of type "image"

For each MediaEntry, get Metadata and

- associated MediaFile and all the Previews for it

Honor public permissions:  
ignore/hide any MediaEntry and Collection where `get_metadata_and_previews` is not `TRUE`.
(Note that Permissions are only pertaining to the Resource itself,
so there is no "inheritance by nesting" or similar. E.g. a public collection can
contain public and non-public Resources.)

Simplification for first version:

- no "custom URLs"
- only meta data of type text
- no previews for set (cover)
- no metaKey label

## example query + data

example set: https://medienarchiv.zhdk.ch/entries/socospa_diagram_5061

### GraphQL request

```graphql
{
  set(id: "e9f34e2c-b844-4297-b701-7e512c65e3b5") {
    id
    url
    metaData {
      nodes {
        id
        metaKey {
          id
        }
        values {
          string
        }
      }
    }
    childMediaEntries(mediaTypes: [IMAGE]) {
      nodes {
        id
        url
        metaData {
          nodes {
            id
            metaKey {
              id
            }
            values {
              string
            }
          }
        }
        mediaFile {
          previews(mediaTypes: [IMAGE]) {
            nodes {
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
}

# every `url` field means full absolute URL with hostname!
# assumes enum MediaEntryMediaTypes { IMAGE }
# assumes enum MetaDataTypes { TEXT }
# assumes enum PreviewMediaTypes { IMAGE }
# assumes enum PreviewSizeClasses { SMALL SMALL_125 MEDIUM LARGE X_LARGE MAXIMUM }
```

### JSON response

```json
{
  "set": {
    "id": "e9f34e2c-b844-4297-b701-7e512c65e3b5",
    "url": "https://medienarchiv.zhdk.ch/sets/e9f34e2c-b844-4297-b701-7e512c65e3b5",
    "metaData": [
      {
        "id": "623a26bd-d5f3-4bdb-bbff-4b637c7120d0",
        "metaKey": {
          "id": "madek_core:title"
        },
        "values": [
          {
            "string": "Colour Systems"
          }
        ]
      }
    ],
    "childMediaEntries": [
      {
        "id": "031da6bf-45d5-4fcf-96d9-3f328696bdfa",
        "url": "https://medienarchiv.zhdk.ch/entries/031da6bf-45d5-4fcf-96d9-3f328696bdfa",
        "metaData": [
          {
            "id": "aa63d66a-a158-4595-adc8-d38e13a8b621",
            "metaKey": {
              "id": "madek_core:title"
            },
            "values": [
              {
                "string": "Colour Circle"
              }
            ]
          }
        ],
        "mediaFile": {
          "previews": [
            {
              "id": "5314d4a7-3aa5-45e5-8682-a7309bca63fe",
              "url": "https://medienarchiv.zhdk.ch/media/5314d4a7-3aa5-45e5-8682-a7309bca63fe",
              "contentType": "image/jpeg",
              "mediaType": "image",
              "sizeClass": "MAXIMUM"
            }
          ]
        }
      }
    ]
  }
}
```

---

see this doc for use case description.
you can make changes to query/data examples if you think it better suits the use case or implementation.
in particular, you can use a relay-style connection instead of simple lists.
timeline: lets check on monday the 17. if first version by friday 21. is possible.
