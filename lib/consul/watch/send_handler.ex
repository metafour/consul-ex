defmodule Consul.Watch.SendHandler do
    use GenEvent

    @doc false
    def handle_event(event, %{pid: pid} = state) do
      send(pid, event)
      {:ok, state}
    end
end
