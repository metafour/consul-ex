#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Agent do
  alias Consul.Endpoint
  use Consul.Endpoint, handler: Consul.Handler.Base

  @agent       "agent"
  @checks      "checks"
  @force_leave "force-leave"
  @join        "join"
  @members     "members"
  @self        "self"
  @services    "services"

  @spec checks(Keyword.t) :: Endpoint.response
  def checks(opts \\ []) do
    req_get([@agent, @checks], opts)
  end

  @spec join(binary, Keyword.t) :: Endpoint.response
  def join(address, opts \\ []) do
    req_get([@agent, @join, address], opts)
  end

  @spec force_leave(binary, Keyword.t) :: Endpoint.response
  def force_leave(node, opts \\ []) do
    req_get([@agent, @force_leave, node], opts)
  end

  @spec members(Keyword.t) :: Endpoint.response
  def members(opts \\ []) do
    req_get([@agent, @members], opts)
  end

  @spec self(Keyword.t) :: Endpoint.response
  def self(opts \\ []) do
    req_get([@agent, @self], opts)
  end

  @spec services(Keyword.t) :: Endpoint.response
  def services(opts \\ []) do
    req_get([@agent, @services], opts)
  end
end
