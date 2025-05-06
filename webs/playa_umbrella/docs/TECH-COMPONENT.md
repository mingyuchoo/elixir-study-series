# Component

## 나만의 콤포넌트 만들기

1. 컴포넌트 디렉터리 구조 설정
2. 컴포넌트 모듈 생성
3. 컴콤포넌트 사용

### 1. 컴포넌트 디렉터리 구조 설정

컴포넌트를 저장할 디렉터리를 만듭니다. 대부분의 Phoenix 앱에서는 `lib/{my_app_web}/components` 경로를 사용합니다.
`{my_app_web}` 부분은 애플리케이션의 웹 모듈 이름으로 대체해야 합니다.

```bash
mkdir lib/my_app_web/components
```

### 2. 컴포넌트 모듈 생성

컴포넌트에 대한 Elixir 모듈을 생성합니다.
이 모듈에서는 Phoenix의 LiveView API를 사용하여 컴포넌트의 기능을 정의합니다.

`lib/{my_app_web}/components/my_component.ex` 파일을 만듭니다:

```elixir
defmodule MyAppWeb.MyComponents do
  @moduledoc """
  Provides Playa UI components
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import MyAppWeb.Gettext

  @doc """
  Renders a button.

  ## Examples
      <.my_button>Click!</.my_button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def my_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
```

### 3. 컴콤포넌트 사용

Phoenix 앱에서는 `lib/{my_app_web}.ex` 파일에 해당 콤포넌트를 임포트합니다.

```elixir
...

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import PlayaWeb.CoreComponents
      import PlayaWeb.Gettext

      # NOTE:
      # My UI components
      import MyAppWeb.MyComponents

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

...
```

사용하고자 하는 `*.html.heex` 파일에 새로 만든 컴포넌트를 넣어 사용합니다.

```elixir:index.html.heex
...

<.my_button>
  My Component Button
</.my_button>

...
```
