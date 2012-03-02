class ExceptionLog < ActiveRecord::Base
  serialize :backtrace
end
