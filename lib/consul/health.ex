#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Health do
  alias Consul.Endpoint
  use Consul.Endpoint, handler: Consul.Handler.Base

  @checks  "checks"
  @health  "health"
  @node    "node"
  @service "service"
  @state   "state"

  @spec checks(binary, Keyword.t) :: Endpoint.response
  def checks(id, opts \\ []) do
    req_get([@health, @checks, id], opts)
  end

  @spec node(binary, Keyword.t) :: Endpoint.response
  def node(id, opts \\ []) do
    req_get([@health, @node, id], opts)
  end

  @spec service(binary, Keyword.t) :: Endpoint.response
  def service(id, opts \\ []) do
    req_get([@health, @service, id], opts)
      |> req_get()
  end

  @spec state(binary, Keyword.t) :: Endpoint.response
  def state(id, opts \\ []) do
    req_get([@health, @state, id], opts)
  end
end
