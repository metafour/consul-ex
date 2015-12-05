#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Session do
  alias Consul.Endpoint
  use Consul.Endpoint, handler: Consul.Handler.Base

  @session "session"
  @create  "create"
  @destroy "destroy"
  @info    "info"
  @list    "list"
  @node    "node"
  @renew   "renew"

  @spec create(map, Keyword.t) :: Endpoint.response
  def create(body, opts \\ []) do
    req_put([@session, @create], Poison.encode!(body), opts)
  end

  @spec create!(map, Keyword.t) :: binary | no_return
  def create!(body, opts \\ []) do
    case create(body, opts) do
      {:ok, %{body: body}} ->
        body["ID"]
      {:error, response} ->
        raise Consul.ResponseError, response
    end
  end

  @spec destroy(binary, Keyword.t) :: Endpoint.response
  def destroy(session_id, opts \\ []) do
    req_put([@session, @destroy, session_id], "", opts)
  end

  @spec info(binary, Keyword.t) :: Endpoint.response
  def info(session_id, opts \\ []) do
    req_get([@session, @info, session_id], opts)
  end

  @spec node(binary, Keyword.t) :: Endpoint.response
  def node(node_id, opts \\ []) do
    req_get([@session, @node, node_id], opts)
  end

  @spec list(Keyword.t) :: Endpoint.response
  def list(opts \\ []) do
    req_get([@session, @list], opts)
  end

  @spec renew(binary, Keyword.t) :: Endpoint.response
  def renew(session_id, opts \\ []) do
    req_put([@session, @renew, session_id], "", opts)
  end
end
