defmodule Sequence.Application do
  @moduledoc """
  Sequence 애플리케이션 시작 모듈
  """
  use Application

  @impl true
  def start(_type, _args) do
    # 수퍼바이저가 관리할 자식 프로세스 정의
    children = [
      # Stash는 상태를 유지하는 역할
      {Sequence.Stash, Application.get_env(:sequence, :initial_number)},
      # Server는 실제 시퀀스 기능 제공
      {Sequence.Server, nil}
    ]

    # 수퍼바이저 옵션 설정
    # rest_for_one: 실패한 프로세스와 그 뒤에 정의된 모든 프로세스를 재시작
    opts = [strategy: :rest_for_one, name: Sequence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
