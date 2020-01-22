class ApplicationController < ActionController::API

  def root
    homepage = <<~HTML.html_safe
    <!DOCTYPE html>
    <h1>Madek GraphQL API</h1>
    <h2>Development links:</h2>
    <ul>
      <li>
        <a href="/graphql">GraphiQL API Endpoint (<samp>POST</samp> and <samp>GET</samp>)</a>
        <ul>
          <li><a href="/graphql?query={firstEntry:allMediaEntries(first:1){id}}"><samp>GET</samp> example</a></li>
        </ul>
      </li>
      <li><a href="/graphql/graphiql">GraphiQL UI</a></li>
    </ul>
    HTML

    render html: homepage
  end
end
