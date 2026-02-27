module SystemTestHelper
  MOBILE_VIEWPORTS = [
    [ 375, 812 ],
    [ 430, 932 ]
  ].freeze

  def sign_in(email_address, password = "secret123456")
    visit root_url

    fill_in "email_address", with: email_address
    fill_in "password", with: password

    click_on "log_in"
    assert_selector ".rooms a", wait: 10
  end

  def wait_for_cable_connection
    assert_selector "turbo-cable-stream-source[connected]", minimum: 1, visible: false, wait: 10
  end

  def join_room(room)
    with_stale_retry { visit room_url(room) }
    with_stale_retry do
      wait_for_cable_connection
      dismiss_pwa_install_prompt
    end
  end

  def send_message(message)
    fill_in_rich_text_area "message_body", with: message
    click_on "send"
  end

  def within_message(message, &block)
    with_stale_retry do
      selector = "#" + dom_id(message)
      assert_selector selector, wait: 10
      within selector, &block
    end
  end

  def assert_message_text(text, **options)
    assert_selector ".message__body", text: text, **options
  end

  def assert_room_read(room)
    assert_selector ".rooms a", class: "!unread", text: "#{room.name}", wait: 5
  end

  def assert_room_unread(room)
    assert_selector ".rooms a", class: "unread", text: "#{room.name}", wait: 5
  end

  def reveal_message_actions
    find(".message__options-btn").click
    rescue Capybara::ElementNotFound
      find(".message__options-btn", visible: false).hover.click
    ensure
      assert_selector ".message__boost-btn", visible: true
  end

  def dismiss_pwa_install_prompt
    if page.has_css?("[data-pwa-install-target~='dialog']", visible: :visible, wait: 5)
      click_on("Close")
    end
  end

  def each_mobile_viewport(&block)
    MOBILE_VIEWPORTS.each do |width, height|
      with_mobile_viewport(width: width, height: height) do
        block.call(width, height)
      end
    end
  end

  def with_mobile_viewport(width:, height:)
    original_size = page.driver.browser.manage.window.size
    page.driver.browser.manage.window.resize_to(width, height)
    yield
  ensure
    page.driver.browser.manage.window.resize_to(original_size.width, original_size.height)
  end

  def assert_no_horizontal_overflow
    assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth + 1"), "Document overflowed horizontally"
    assert page.evaluate_script("document.body.scrollWidth <= window.innerWidth + 1"), "Body overflowed horizontally"
  end

  def open_sidebar
    find("#sidebar .sidebar__toggle", visible: :all).click
    assert_selector "#sidebar.open", visible: :all, wait: 5
  end

  private
    def with_stale_retry(max_attempts: 5)
      attempts = 0

      begin
        yield
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        attempts += 1
        raise if attempts >= max_attempts
        sleep 0.1
        retry
      end
    end
end
