defmodule BlockerLists do
  alias BlockerLists.Sources

  def regenerate do
    domains = (Sources.StevenBlack.domains() ++ Sources.CertPolska.domains()) |> sanitize()
    domains_with_social = (Sources.StevenBlack.domains_with_social() ++ Sources.CertPolska.domains()) |> sanitize()

    File.write!("blockerList.json", build_ios(domains))
    File.write!("brave.txt", build_brave(domains))
    File.write!("brave-with-social.txt", build_brave(domains_with_social))
  end

  defp sanitize(domains) do
    Enum.filter(domains, &String.match?(&1, ~r/^[[:alnum:]\_\-\.]+$/))
  end

  defp build_ios(domains) do
    [
      %{
        action: %{
          type: "block"
        },
        trigger: %{
          "url-filter": ".*",
          "if-domain": domains
        }
      }
    ]
    |> Jason.encode!()
  end

  defp build_brave(domains) do
    "[Adblock Plus 1.1]\n" <> Enum.map_join(domains, &"||#{&1}^\n")
  end
end
