import React from "react";
import Head from "next/head";
import Nav from "../components/nav";
import {setWithChildrenForGalleryQuery, PAGE_SIZE} from "./set-slideshow/[id]"

const Home = () => (
  <div>
    <div className="hero">
      <h1 className="title">Madek Set Slideshow Prototype</h1>

      <p className="description">
        example sets:
        <ul>
          <li>
            <a href="set-slideshow/e9f34e2c-b844-4297-b701-7e512c65e3b5">
              "Colour Systems"
            </a>
          </li>
          <li>
            <a href="set-slideshow/36e9c917-8c2b-4fe2-a389-fdd4a0602c43">
              "Ikonografie der Trostschrift"
            </a>
          </li>
          <li>
            <a href="set-slideshow/3ec95285-9efe-434f-82fe-2a5d60bc489a">
              "Hands-on IFCAR"
            </a>
          </li>
        </ul>
      </p>

      <p className="description">
        tech:
        <ul>
          <li>
            slideshow built with <a href="https://fancyapps.com/fancybox/3/">
              <code>fancybox 3</code>
            </a>
          </li>
          <li>
            this site built with <a href="https://nextjs.org">
              <code>next.js</code>
            </a>
          </li>
          <li>
            hosted on <a href="https://now.sh">
              <code>now.sh</code>
            </a>
          </li>
          <li>
            <a href="https://github.com/Madek/madek-graphql-api/tree/examples/set-slideshow/examples/set-slideshow">
              source code for this site
            </a>
          </li>
        </ul>
      </p>

      <p className="description">
        data
        <ul>
          <li>
            Graphql API: <a href={process.env.API_URL}>
              {process.env.API_URL}
            </a>
          </li>
          <li>
            Graph<i>i</i>ql API UI: <a href={process.env.API_URL + '/graphiql'}>
              {process.env.API_URL + '/graphiql'}
            </a>
          </li>
          <li>
            used query:
            <pre>{String(setWithChildrenForGalleryQuery).trim()}
            </pre>
            with variables:
            <pre>{JSON.stringify({setId: "e9f34e2c-b844-4297-b701-7e512c65e3b5", limit: PAGE_SIZE})}
            </pre>
          </li>
        </ul>
      </p>

    </div>
  </div>
);

export default Home;
