#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Agent.Service do
  alias Consul.Endpoint
  use Consul.Endpoint, handler: Consul.Handler.Base

  @agent      "agent"
  @deregister "deregister"
  @register   "register"
  @service    "service"

  @spec register(map, Keyword.t) :: Endpoint.response
  def register(%{"Name" => _} = body, opts \\ []) do
    req_put([@agent, @service, @register], Poison.encode!(body), opts)
  end

  @spec deregister(binary, Keyword.t) :: Endpoint.response
  def deregister(id, opts \\ []) do
    req_delete([@agent, @service, @deregister, id], opts)
  end
end
