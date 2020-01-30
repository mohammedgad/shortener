defmodule Shortener.Redis do
  use Agent

  @type response :: {:ok, Redix.Protocol.redis_value()} | {:error, atom | Redix.Error.t()}

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_) do
    Agent.start_link(&start_server/0, name: __MODULE__)
  end

  defp start_server do
    with [host: host] <- get_host(),
         {:ok, conn} <- Redix.start_link(host) do
      conn
    end
  end

  defp get_host do
    Application.get_env(:shortener, Shortener.Redis, :host)
  end

  def conn do
    Agent.get(__MODULE__, fn conn -> conn end)
  end

  @spec get(key :: String.t()) :: response
  def get(key) when is_binary(key), do: Redix.command(conn(), ["GET", key])

  @spec delete(key :: String.t()) :: response
  def delete(key) when is_binary(key), do: Redix.command(conn(), ["DEL", key])

  @spec set(key :: String.t(), value :: String.t()) :: response
  def set(key, value), do: Redix.command(conn(), ["SET", key, value])

  @spec set(key :: String.t(), value :: String.t(), ttl :: integer) :: response
  def set(key, value, ttl) when is_binary(key) and is_binary(value) and is_integer(ttl) do
    Redix.command(conn(), ["SET", key, value, "EX", ttl])
  end
end
