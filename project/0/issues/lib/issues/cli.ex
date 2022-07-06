defmodule Issues.CLI do
  @default_count 4
  @moduledoc """
  명령줄 파싱을 수행한 뒤, 각족 함수를 호출해
  깃허브 프로젝트의 최근 _n_개 이슈를 표 모양으로
  출력한다.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  'argv'는 -h 또는 --help(이 경우 :help를 반환)이거나,
  깃허브 사용자 이름, 프로젝트 이름, (선택적으로) 가져올
  이슈 개수여야 한다.

  '{사용자명, 프로젝트명, 이슈 개수}' 또는 :help를 반환한다.
  """

  def parse_args(argv) do
    OptionParser.parse(argv,
                       switches: [ help: :boolean ],
                       aliases: [ h: :help ])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([ user, project, count ]), do: { user, project, String.to_integer(count) }
  def args_to_internal_representation([ user, project        ]), do: { user, project, @default_count }
  def args_to_internal_representation(_                       ), do: :help


  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end
  def project({ user, project, _count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
  end

  def decode_response({ :ok, body }), do: body
  def decode_response({ :error, error }) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end
end
