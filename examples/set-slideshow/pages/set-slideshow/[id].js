import React from "react";
import { useRouter } from "next/router";
import Head from "next/head";
import { useQuery } from "graphql-hooks";

// const PAGE_SIZE = 12;
export const PAGE_SIZE = 2500;

const Page = () => {
  const router = useRouter();
  const { id } = router.query;

  return (
    <React.Fragment>
      <Head>
        <title>Slideshow!</title>
        <meta name="viewport" content="initial-scale=1.0, width=device-width" />
        {FancyBoxJsTop()}
      </Head>

      <SetSlideshow setId={id} />

      <FancyBoxJSBottom />
    </React.Fragment>
  );
};

export default Page;

export const setWithChildrenForGalleryQuery = `
  query setWithChildrenForGallery($setId: ID!, $limit: Int = 100) {
    set(id: $setId) {
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
      childMediaEntries(first: $limit, mediaTypes: [IMAGE]) {
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
`;

const SetSlideshow = ({ setId }) => {
  const { loading, error, data, ...request } = useQuery(
    setWithChildrenForGalleryQuery,
    {
      variables: { setId, limit: PAGE_SIZE }
    }
  );

  if (loading) {
    return (
      <div className="row no-gutters mb-4 mx-4 my-5 text-center">
        <p className="text-center h3 w-100">{"⚡️ Loading…"}</p>
      </div>
    );
  }

  if (error) {
    const errMsg = ["fetchError", "httpError", "graphQLErrors"].reduce(
      (m, k) => ({
        ...m,
        [k]: (request[k] && request[k].message) || request[k]
      }),
      {}
    );
    console.error(errMsg);
    return (
      <div className="row no-gutters mb-4 mx-4 my-5">
        <p className="text-center h3 w-100">{"💀 Error!"}</p>
        <pre className="m-6 mx-auto alert alert-danger">
          {JSON.stringify(errMsg, 0, 2)}
        </pre>
      </div>
    );
  }

  const { set } = data;
  const entries = set.childMediaEntries.nodes;
  const title = metaDatumStringByKey("madek_core:title", set);

  return (
    <React.Fragment>
      <header className="row mb-4 ml-4 my-5">
        <h1>{title}</h1>
      </header>
      <div className="mx-4">
        <button
          type="button"
          className="btn btn-outline-dark"
          onClick={() =>
            $.fancybox.open($("[data-fancybox]"), {
              arrows: false,
              slideShow: { autoStart: true },
              fullScreen: { autoStart: true }
            })
          }
        >
          ▶︎ PLAY
        </button>
      </div>
      <EntriesGallery entries={entries} />
    </React.Fragment>
  );
};

function metaDatumStringsByKey(key, resource) {
  const mds = resource.metaData.nodes.filter(md => md.metaKey.id === key);
  if (!mds[0]) return;
  return mds[0].values.map(v => v.string);
}
function metaDatumStringByKey(key, resource) {
  const mdvs = metaDatumStringsByKey(key, resource);
  if (mdvs && mdvs[0]) return mdvs[0];
}
const IMG_SIZE_CLASSES = [
  "MAXIMUM",
  "X_LARGE",
  "LARGE",
  "MEDIUM",
  "SMALL",
  "SMALL_125"
];
function sizeClassOrder(p) {
  return IMG_SIZE_CLASSES.indexOf(p.sizeClass);
}
function sortPreviewsBySize(previews) {
  const ps = [...previews];
  ps.sort((a, b) => sizeClassOrder(a) - sizeClassOrder(b));
  return ps;
}
function previewOfSize(sizeClass, previews) {
  const wantedOrHigher = IMG_SIZE_CLASSES.slice(
    0,
    sizeClassOrder({ sizeClass }) + 1
  );
  const allPs = sortPreviewsBySize(previews);
  const ps = allPs.filter(p => wantedOrHigher.includes(p.sizeClass)).reverse();
  if (ps[0]) return ps[0];
}

const EntriesGallery = ({ entries }) => (
  <React.Fragment>
    <div className="ui-gallery row no-gutters mb-4 mx-4 my-5">
      {entries.map(entry => {
        const title = metaDatumStringByKey("madek_core:title", entry);
        const date = metaDatumStringByKey(
          "madek_core:portrayed_object_date",
          entry
        );
        const source = metaDatumStringByKey("copyright:source", entry);
        const authors = metaDatumStringsByKey("madek_core:authors", entry);
        const previews = sortPreviewsBySize(entry.mediaFile.previews.nodes);
        const thumb = previewOfSize("MEDIUM", previews);
        const fullSize = previewOfSize("MAXIMUM", previews);

        const authorsLine = (authors || ["Unbekannt"]).join(", ");
        const captionLine =
          authors && date
            ? `${authorsLine} (${date})`
            : source
            ? source
            : `${authorsLine}`;

        return (
          <figure className="col-6 col-md-3 col-lg-2 pb-4 pr-4">
            <a
              className="ui-fig-a d-block mb-4"
              data-fancybox="images"
              href={fullSize.url}
              data-caption={`${title} | ${captionLine}`}
            >
              <img className="img-fluid" src={thumb.url} />
            </a>
            <figcaption>
              <h6>{title}</h6>
              <a href={entry.url}>{captionLine}</a>
            </figcaption>
          </figure>
        );
      })}
    </div>
    {/* <pre style={{ margin: "5rem" }}>{JSON.stringify({ entries }, 0, 2)}</pre> */}
  </React.Fragment>
);

const FancyBoxJsTop = () => (
  <React.Fragment>
    {/* fancybox CSS */}
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.css"
      integrity="sha256-Vzbj7sDDS/woiFS3uNKo8eIuni59rjyNGtXfstRzStA="
      crossOrigin="anonymous"
    />
    {/* site CSS  */}
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css"
      integrity="sha256-YLGeXaapI0/5IgZopewRJcFXomhRMlYYjugPLSyNjTY="
      crossOrigin="anonymous"
    />
    <style media="screen">{`
        .ui-gallery figure a img {
            max-height: 20rem;
        }
        .fancybox-is-open.fancybox-is-fullscreen .fancybox-bg {
            opacity: 1;
        }
        `}</style>
  </React.Fragment>
);

const FancyBoxJSBottom = () => (
  <React.Fragment>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"
      integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
      crossOrigin="anonymous"
    ></script>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.js"
      integrity="sha256-yt2kYMy0w8AbtF89WXb2P1rfjcP/HTHLT7097U8Y5b8="
      crossOrigin="anonymous"
    ></script>

    <InlineScript>{`
      $(function() {
        var conf = $.fancybox.defaults;

        conf.loop = true;
        conf.image.preload = true;
        conf.idleTime = 5;
        conf.buttons = [
          "thumbs",
          "zoom",
          "download",
          "slideShow",
          "fullScreen",
          //"share",
          "close"
        ];
      });
    `}</InlineScript>
  </React.Fragment>
);

const InlineScript = ({ children, type = "text/javascript" }) => (
  <script type={type} dangerouslySetInnerHTML={{ __html: children }}></script>
);
