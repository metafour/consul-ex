#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Endpoint do
  @path_separator "/"
  @timeout_delay  1000

  @type response :: {:ok, Consul.Response.t} | {:error, Consul.Response.t}

  @spec build_url(binary | [binary], Keyword.t) :: binary
  def build_url(path, opts \\ [])
  def build_url(path, opts) when is_list(path) do
    List.flatten(path)
      |> Enum.join(@path_separator)
      |> build_url(opts)
  end
  def build_url(path, []), do: path
  def build_url(path, opts) when is_binary(path) do
    path <> "?" <> URI.encode_query(opts)
  end

  @spec build_options(Keyword.t, Keyword.t) :: Keyword.t
  def build_options(params, options) do
    case Keyword.get(params, :wait) do
      nil -> options
      dur -> Keyword.merge([recv_timeout: parse_duration(dur) * 1000 + @timeout_delay], options)
    end
  end


  defp parse_duration(s) when is_binary(s), do: parse_duration(s, {[], 0})

  defp parse_duration(<<>>, {_, sec}), do: sec
  defp parse_duration(<< x, rest :: binary >>, {buf, sec}) when x >= ?0 and x <= ?9,
    do: parse_duration(rest, {[x|buf], sec})
  defp parse_duration(<< ?s, rest :: binary >>, {buf, sec}),
    do: parse_duration(rest, {[], sec + List.to_integer(Enum.reverse(buf))})
  defp parse_duration(<< ?m, rest :: binary >>, {buf, sec}),
    do: parse_duration(rest, {[], sec + List.to_integer(Enum.reverse(buf)) * 60})
  defp parse_duration(<< ?h, rest :: binary >>, {buf, sec}),
    do: parse_duration(rest, {[], sec + List.to_integer(Enum.reverse(buf)) * 3600})
  defp parse_duration(_, _), do: raise(ArgumentError, "Invalid consul duration")

  defmacro __using__(handler: handler) do
    quote do
      alias Consul.Request, as: Request
      import unquote(__MODULE__), only: [build_url: 1, build_url: 2, build_options: 2]

      defp req_get(path, params \\ [], headers \\ [], options \\ []) do
        url     = build_url(path, params)
        options = build_options(params, options)
        Request.get(url, headers, options) |> handle_response
      end

      defp req_put(path, body, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.put(url, body, headers, options) |> handle_response
      end

      defp req_head(path, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.head(url, headers, options) |> handle_response
      end

      defp req_post(path, body, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.post(url, body, headers, options) |> handle_response
      end

      defp req_patch(path, body, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.patch(url, body, headers, options) |> handle_response
      end

      defp req_delete(path, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.delete(url, headers, options) |> handle_response
      end

      defp req_options(path, params \\ [], headers \\ [], options \\ []) do
        url = build_url(path, params)
        Request.options(url, headers, options) |> handle_response
      end

      defp handle_response({:ok, response}), do: unquote(handler).handle(response)
      defp handle_response({:error, _} = error), do: error
    end
  end
end
