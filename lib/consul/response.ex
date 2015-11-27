#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Response do
  @type t :: HTTPoison.Response.t

  @spec consul_index(t) :: integer | nil
  def consul_index(%{headers: headers}) do
    case List.keyfind(headers, "X-Consul-Index", 0) do
      {_, index} -> index
      _ -> nil
    end
  end
  def consul_index(_), do: nil
end
