# Repository Guidelines

## Project Structure & Module Organization
Campfire is a Rails 8 app. Core code lives in `app/`:
- `app/models`, `app/controllers`, `app/jobs`, `app/channels`, `app/views`
- `app/javascript` for Stimulus controllers and client helpers
- `app/assets` for styles, images, and sounds

Configuration is in `config/`, DB schema/migrations in `db/`, reusable Ruby code in `lib/`, and operational scripts in `bin/` and `script/` (for example `script/admin/reset-password`). Tests are under `test/` with subfolders matching app layers (`test/models`, `test/controllers`, `test/system`, etc.).

## Build, Test, and Development Commands
- `bin/setup`: installs dependencies, prepares DB, and readies local services.
- `bin/dev` or `bin/rails server`: starts the app locally.
- `bin/rails test`: runs unit/integration test suite.
- `bin/rails test:system`: runs system tests.
- `bin/ci`: runs setup, RuboCop, security checks, and all tests (best pre-PR gate).
- `docker build -t campfire .`: builds production container image.

## Coding Style & Naming Conventions
Ruby style is enforced with RuboCop Omakase (`.rubocop.yml`, `bin/rubocop`).
- Use 2-space indentation.
- Use `snake_case` for methods/files, `CamelCase` for classes/modules.
- Prefer small, focused methods and Rails conventions over custom patterns.

JavaScript uses ES modules + Stimulus in `app/javascript/controllers`.
- Name controllers `*_controller.js`.
- Keep DOM behavior in controllers and shared logic in `app/javascript/helpers` or `models`.

## Testing Guidelines
The project uses Minitest (`test/test_helper.rb`) with fixtures from `test/fixtures`.
- Name tests `*_test.rb`.
- Mirror production paths (for example `app/models/message.rb` -> `test/models/message_test.rb`).
- For focused runs: `bin/rails test test/models/message_test.rb`.
- Add/adjust system tests for UI or real-time behavior changes.

## Commit & Pull Request Guidelines
Recent commits use short, imperative subjects (for example `Delete server-side session on logout`).
- Keep subject lines concise and action-oriented.
- Group related changes per commit.
- Run `bin/ci` before opening a PR.

Contribution flow follows `CONTRIBUTING.md`: start with GitHub Discussions for ideas/questions, and use Issues for actionable/reproducible work. PRs should include context, linked issue/discussion, and screenshots for UI changes.

## Security & Configuration Tips
Do not commit secrets. Use environment variables for runtime config (`SECRET_KEY_BASE`, `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, `SENTRY_DSN`). Run `bin/brakeman`, `bin/bundler-audit`, and `bin/importmap audit` for security checks.
