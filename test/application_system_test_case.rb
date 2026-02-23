require "test_helper"

WebMock.disable!

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  self.use_transactional_tests = false
  Capybara.server = :puma, { Silent: true, Threads: "1:1" }

  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  include SystemTestHelper
end
