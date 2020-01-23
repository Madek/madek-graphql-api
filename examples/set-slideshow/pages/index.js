import React from "react";
import Head from "next/head";
import Nav from "../components/nav";

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
    </div>
  </div>
);

export default Home;
