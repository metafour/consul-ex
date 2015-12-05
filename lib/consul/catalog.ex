#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Catalog do
  alias Consul.Endpoint
  use Consul.Endpoint, handler: Consul.Handler.Base

  @catalog     "catalog"
  @datacenters "datacenters"
  @deregister  "deregister"
  @nodes       "nodes"
  @node        "node"
  @services    "services"
  @service     "service"

  @spec datacenters(Keyword.t) :: Endpoint.response
  def datacenters(opts \\ []) do
    req_get([@catalog, @datacenters], opts)
  end

  @spec deregister(map, Keyword.t) :: Endpoint.response
  def deregister(%{"Datacenter" => _, "Node" => _} = body, opts \\ []) do
    req_put([@catalog, @deregister], Poison.encode!(body), opts)
  end

  @spec nodes(Keyword.t) :: Endpoint.response
  def nodes(opts \\ []) do
    req_get([@catalog, @nodes], opts)
  end

  @spec node(binary, Keyword.t) :: Endpoint.response
  def node(id, opts \\ []) do
    req_get([@catalog, @node, id], opts)
  end

  @spec services(Keyword.t) :: Endpoint.response
  def services(opts \\ []) do
    req_get([@catalog, @services], opts)
  end

  @spec service(binary, Keyword.t) :: Endpoint.response
  def service(name, opts \\ []) do
    req_get([@catalog, @service, name], opts)
  end
end
