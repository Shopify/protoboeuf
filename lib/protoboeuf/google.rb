# frozen_string_literal: true

# There isn't a clean 1:1 mapping between constants and *.rb files, so eager load instead of autoload.

Dir[File.expand_path("google/**/*.rb", __dir__)].each { |file| require file }
