defmodule Sequence do
  @moduledoc """
  Sequence 애플리케이션 메인 모듈
  """

  @doc """
  애플리케이션 시작 지점
  mix run -e Sequence.main 명령어로 실행 가능
  """
  def main(args \\ []) do
    IO.puts("Sequence 애플리케이션이 시작되었습니다.")
    IO.puts("현재 숫자: #{Sequence.Server.next_number()}")
    
    # 예제로 10을 증가시킴
    Sequence.Server.increment_number(10)
    IO.puts("10 증가 후 숫자: #{Sequence.Server.next_number()}")
    
    # 사용자 입력 인자가 있는 경우 처리
    case args do
      [increment_str | _] ->
        case Integer.parse(increment_str) do
          {increment, _} ->
            Sequence.Server.increment_number(increment)
            IO.puts("#{increment} 증가 후 숫자: #{Sequence.Server.next_number()}")
          :error ->
            IO.puts("유효한 숫자를 입력해주세요.")
        end
      [] -> :ok
    end
    
    # 애플리케이션이 계속 실행되도록 하기 위해 무한 대기
    # 실제 사용 시에는 이 부분을 제거하고 필요한 로직을 추가하세요
    Process.sleep(:infinity)
  end

  @doc """
  현재 숫자를 반환하고 1 증가시킵니다.
  """
  def next_number do
    Sequence.Server.next_number()
  end

  @doc """
  현재 숫자를 주어진 값만큼 증가시킵니다.
  """
  def increment_number(delta) do
    Sequence.Server.increment_number(delta)
  end
end
