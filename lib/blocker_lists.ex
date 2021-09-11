defmodule BlockerLists do
  alias BlockerLists.Sources

  def regenerate do
    File.write!("blockerList.json", build_json())
  end

  def build_json do
    [
      %{
        action: %{
          type: "block"
        },
        trigger: %{
          "url-filter": ".*",
          "if-domain": blocked_domains()
        }
      }
    ]
    |> Jason.encode!()
  end

  defp blocked_domains do
    Sources.StevenBlack.domains() ++ Sources.CertPolska.domains()
  end
end
