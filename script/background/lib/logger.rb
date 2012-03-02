class Logger
  def format_message(severity, timestamp, progname, msg)
    "[#{timestamp.to_s} PID:#{$$}] #{msg}\n"
  end
end