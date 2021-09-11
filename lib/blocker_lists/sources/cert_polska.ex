defmodule BlockerLists.Sources.CertPolska do
  def domains do
    %{body: body, status_code: 200} = HTTPoison.get!("https://hole.cert.pl/domains/domains.txt")

    body
    |> String.split("\n", trim: true)
  end
end
