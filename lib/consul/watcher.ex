defmodule Consul.Watcher do
  use GenServer

  @wait     "10m"
  @retry_ms 30 * 1000

  alias Consul.Watch

  @spec start_link(Watch.t) :: GenServer.on_start
  def start_link(watch) do
    GenServer.start_link(__MODULE__, [watch])
  end

  #
  # GenServer callbacks
  #

  def init([%Watch{type: type, args: args, handlers: handlers, index: index}]) do
    {:ok, em} = GenEvent.start_link()

    Enum.each handlers, fn
      {handler, args} ->
        :ok = GenEvent.add_handler(em, handler, args)
      handler ->
        :ok = GenEvent.add_handler(em, handler, [])
    end

    {:ok, %{type: type, args: args, em: em, index: index, hash: nil}, 0}
  end

  def handle_info(:timeout, %{type: type, args: args, index: index, em: em, hash: hash} = state) do
    case do_watch(type, args, index) do
      {:ok, %{body: body} = response} ->
        new_index = Consul.Response.consul_index(response)
        case :erlang.phash2(body) do
          ^hash ->
            {:noreply, %{state | index: new_index}, 0}
          new_hash ->
            GenEvent.ack_notify(em, {:consul_watch, type, body})
            {:noreply, %{state | index: new_index, hash: new_hash}, 0}
        end
      {:error, %{reason: :timeout}} ->
        {:noreply, state, 100}
      {:error, _} ->
        {:noreply, state, @retry_ms}
    end
  end

  #
  # Private
  #
  defp do_watch(:key, [key], index) do
    Consul.Kv.fetch(key, wait: @wait, index: index)
  end
  defp do_watch(:keyprefix, [prefix], index) do
    Consul.Kv.fetch(prefix, wait: @wait, index: index, recurse: true)
  end
  defp do_watch(:service, [name, tag], index) do
    Consul.Catalog.service(name, wait: @wait, index: index, tag: tag)
  end
  defp do_watch(:health, [name, tag], index) do
    Consul.Health.service(name, wait: @wait, index: index, tag: tag)
  end

end
