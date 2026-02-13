defmodule PlayaWeb.UserLive.ShowTest do
  use PlayaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Playa.AccountsFixtures

  @create_attrs %{email: "test@example.com", password: "password123456", nickname: "testuser"}

  describe "Show" do
    setup do
      user = user_fixture(@create_attrs)
      role = role_fixture(%{name: "Admin", abbr: "ADMIN"})
      %{user: user, role: role}
    end

    test "displays user information", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/accounts/users/#{user.id}")

      assert html =~ "Show User"
      assert html =~ user.email
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, show_live, _html} = live(conn, ~p"/accounts/users/#{user.id}")

      assert show_live
             |> element("a[phx-click='delete'][phx-value-user_id='#{user.id}']")
             |> render_click()

      assert_redirect(show_live, "/accounts/users")
    end

    test "saves new role assignment", %{conn: conn, user: user, role: role} do
      {:ok, show_live, _html} = live(conn, ~p"/accounts/users/#{user.id}")

      assert show_live
             |> form("#role-form", role_user: %{role_id: role.id, user_id: user.id})
             |> render_submit()

      html = render(show_live)
      assert html =~ role.name
    end

    test "deletes role assignment", %{conn: conn, user: user, role: role} do
      # 먼저 역할 할당
      {:ok, _role_user} = Playa.Accounts.create_role_user(%{role_id: role.id, user_id: user.id})

      {:ok, show_live, html} = live(conn, ~p"/accounts/users/#{user.id}")

      # 역할이 표시되는지 확인
      assert html =~ role.name

      # 역할 삭제
      assert show_live
             |> element("button[phx-click='delete_role'][phx-value-role-id='#{role.id}']")
             |> render_click()

      # 역할이 삭제되었는지 확인
      html = render(show_live)
      refute html =~ role.name
    end

    test "validates role assignment form", %{conn: conn, user: user} do
      {:ok, show_live, _html} = live(conn, ~p"/accounts/users/#{user.id}")

      # 잘못된 데이터로 검증
      assert show_live
             |> form("#role-form", role_user: %{role_id: nil, user_id: user.id})
             |> render_change() =~ "can&#39;t be blank"
    end
  end

  describe "Edit" do
    setup do
      user = user_fixture(@create_attrs)
      %{user: user}
    end

    test "displays edit form", %{conn: conn, user: user} do
      {:ok, _edit_live, html} = live(conn, ~p"/accounts/users/#{user.id}/edit")

      assert html =~ "Edit User"
      assert html =~ user.email
    end

    test "updates user successfully", %{conn: conn, user: user} do
      {:ok, edit_live, _html} = live(conn, ~p"/accounts/users/#{user.id}/edit")

      new_nickname = "updated_nickname"

      assert edit_live
             |> form("#user-form", user: %{nickname: new_nickname})
             |> render_submit()

      html = render(edit_live)
      assert html =~ new_nickname
    end
  end
end
