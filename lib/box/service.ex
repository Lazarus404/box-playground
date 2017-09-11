defmodule Box.Service do
  import Joken
  alias Joken.Token

  @token_address "https://api.box.com/oauth2/token"
  @base_address "https://api.box.com/2.0"
  @config Application.get_env(:box, :config_url)
    |> File.read!()
    |> Poison.decode!()

  def create_user(name) do
    body = %{name: name, is_platform_access_only: true}
    |> Poison.encode!()
    request("/users", body)
  end

  def request(uri, params) do
    {:ok, %{"access_token" => token}} = get_service_token()
    header = ["Authorization": "Bearer #{token}"]
    case HTTPotion.post("#{@base_address}#{uri}", [body: params, headers: header]) do
      %HTTPotion.Response{body: body} ->
        {:ok, body |> Poison.decode!()}
      %HTTPotion.ErrorResponse{message: reason} ->
        {:error, reason}
    end
  end

  def get_user_token(user_id), do: jwt_request("user", user_id)
  def get_service_token(), do: jwt_request("enterprise", enterprise_id())

  defp jwt_request(type, id) do
    body = [
      "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer",
      "client_id=#{client_id()}",
      "client_secret=#{client_secret()}",
      "assertion=#{assertion(type, id)}"
    ]
    case HTTPotion.post(@token_address, [body: Enum.join(body, "&")]) do
      %HTTPotion.Response{body: body} ->
        {:ok, body |> Poison.decode!()}
      %HTTPotion.ErrorResponse{message: reason} ->
        {:error, reason}
    end
  end

  defp assertion(type, id) do
    token = %Token{}
    |> with_header_arg("alg", "RS256")
    |> with_header_arg("typ", "JWT")
    |> with_header_arg("kid", public_key_id())
    |> with_claim("iss", client_id())
    |> with_claim("sub", id)
    |> with_claim("box_sub_type", type)
    |> with_claim("aud", @token_address)
    |> with_claim("jti", UUID.uuid1())
    |> with_claim("exp", timestamp() + 45)
    |> with_claim("iat", timestamp())
    |> sign(rs256(private_key()))
    |> get_compact()
  end

  defp timestamp(), do: DateTime.utc_now |> DateTime.to_unix

  defp public_key_id(), do: app_auth()["publicKeyID"]
  defp private_key(), do: JOSE.JWK.from_pem(app_auth()["passphrase"], app_auth()["privateKey"])
  defp app_auth(), do: settings()["appAuth"]
  defp client_id(), do: settings()["clientID"]
  defp client_secret(), do: settings()["clientSecret"]
  defp settings(), do: config()["boxAppSettings"]
  defp enterprise_id(), do: config()["enterpriseID"]
  defp config(), do: @config
end
