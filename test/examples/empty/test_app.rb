require_relative File.join '..', '..', 'support', 'coverage'
require_relative File.join '..', '..', '..', 'lib', 'fix'
require 'spectus'

@app = nil

t = Fix::Test.new @app do
  # empty
end

Spectus.this { t.report.to_s }.MUST Eql:      \
  "\n"                                        \
  "\n"                                        \
  "\n"                                        \
  "Ran 0 tests in #{t.total_time} seconds\n"  \
  "100% compliant - 0 infos, 0 failures, 0 errors\n"

Spectus.this { t.pass? }.MUST :BeTrue
Spectus.this { t.fail? }.MUST :BeFalse