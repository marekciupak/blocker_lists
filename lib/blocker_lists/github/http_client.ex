defmodule BlockerLists.Github.HTTPClient do
  def get_raw!(repo, tag, path) do
    "https://raw.githubusercontent.com/#{repo}/#{tag}/#{path}"
    |> HTTPoison.get!()
    |> Map.take([:body, :headers, :status_code])
  end

  def get_latest_release!(repo) do
    "https://api.github.com/repos/#{repo}/releases/latest"
    |> HTTPoison.get!(%{"Accept" => "application/vnd.github.v3+json"})
    |> Map.take([:body, :headers, :status_code])
  end
end
