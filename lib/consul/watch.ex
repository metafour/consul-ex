defmodule Consul.Watch do
  defstruct type: nil,
            handlers: [],
            args: [],
            index: nil

  @type t :: %__MODULE__{ type: :key | :keyprefix | :service | :event,
                          handlers: [],
                          args: [term],
                          index: String.t }
end
