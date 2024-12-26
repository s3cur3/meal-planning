defmodule MpWeb.LiveViewHelpers do
  import Phoenix.LiveViewTest
  import PhoenixTest

  def await_async(phoenix_test_context) do
    unwrap(phoenix_test_context, fn view ->
      html =
        render_async(view)
        |> tap(fn _html ->
          :sys.get_state(view.pid)
        end)

      {:ok, view, html}
    end)
  end

  def debug_dump(phoenix_test_context) do
    unwrap(phoenix_test_context, fn view ->
      html = render(view)
      IO.puts("Dumped HTML:")
      IO.puts(html)
      {:ok, view, html}
    end)

    phoenix_test_context
  end
end
