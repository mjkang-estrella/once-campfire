require "application_system_test_case"

class MobileResponsivenessTest < ApplicationSystemTestCase
  test "room shell stays usable on mobile" do
    sign_in "jz@37signals.com"

    each_mobile_viewport do
      join_room rooms(:designers)
      assert_selector "#composer", wait: 10

      send_message "Mobile shell check"
      assert_message_text "Mobile shell check"

      assert_selector ".message__options-btn", visible: :all, wait: 10
      all(".message__options-btn", visible: :all).first.click
      assert_selector "details[open]", wait: 5
      assert_no_horizontal_overflow
    end
  end

  test "sidebar closes after selecting a room on mobile" do
    sign_in "jz@37signals.com"

    each_mobile_viewport do
      join_room rooms(:hq)
      open_sidebar

      within "#sidebar" do
        find("a##{dom_id(rooms(:designers), :list)}", visible: :all).click
      end

      assert_no_selector "#sidebar.open", visible: :all, wait: 10
      assert_selector "#nav .room--current", text: "Designers", wait: 10
      assert_no_horizontal_overflow
    end
  end

  test "search layout stays responsive on mobile" do
    sign_in "jz@37signals.com"

    each_mobile_viewport do
      join_room rooms(:designers)
      visit searches_path

      fill_in "q", with: "mobile"
      find(".composer button[type='submit']", visible: :all).click

      assert_selector ".searches__query", wait: 10
      assert_no_horizontal_overflow
    end
  end

  test "profile and account settings remain usable on mobile" do
    sign_in "david@37signals.com"

    each_mobile_viewport do
      visit user_profile_path
      assert_selector "input[name='user[name]']", wait: 10
      assert_selector "textarea[name='user[bio]']"
      assert_no_horizontal_overflow

      visit edit_account_path
      assert_selector "input[name='account[name]']", wait: 10
      assert_no_horizontal_overflow
    end
  end

  test "bots and custom styles panels fit mobile viewport" do
    sign_in "david@37signals.com"

    each_mobile_viewport do
      visit account_bots_path
      assert_selector "h1", text: "Chat bots", wait: 10
      assert_no_horizontal_overflow

      visit edit_account_custom_styles_path
      assert_selector "textarea[name='account[custom_styles]']", wait: 10
      assert_no_horizontal_overflow
    end
  end
end
