defmodule MonitExWeb.CollectorControllerTest do
  use MonitExWeb.ConnCase

  test "parses xml data", %{conn: conn} do
    xml = """
    <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
    </note>
    """

    conn =
      conn
      |> put_req_header("content-type", "application/xml")
      |> put_req_header("accept", "application/xml")
      |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "monit"))
      |> post(Routes.collector_path(conn, :create), xml)

    assert response(conn, 200) =~ "<response>Done</response>"
  end
end
