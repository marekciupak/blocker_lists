defmodule BlockerLists.Sources.StevenBlack do
  alias BlockerLists.Github.HTTPClient, as: GithubAPI

  def domains_with_social do
    build("alternates/fakenews-gambling-porn-social/hosts")
  end

  def domains do
    build("alternates/fakenews-gambling-porn/hosts")
  end

  defp build(path) do
    repo = "StevenBlack/hosts"
    tag = latest_release(repo)

    %{body: body, status_code: 200} = GithubAPI.get_raw!(repo, tag, path)

    body
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line -> String.starts_with?(line, "0.0.0.0 ") end)
    |> Enum.map(fn line -> String.replace_prefix(line, "0.0.0.0 ", "") end)
    |> Enum.reject(fn line -> line == "0.0.0.0" end)
    |> Enum.map(fn line -> Regex.replace(~r/ .*$/, line, "") end)
  end

  defp latest_release(repo) do
    %{body: body, status_code: 200} = GithubAPI.get_latest_release!(repo)
    body |> Jason.decode!() |> Map.fetch!("tag_name")
  end
end
