#custom_logger.rb

class CustomLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    regex = /(([Ee][Rr][Rr][Oo][Rr])|())([^,]*)(,(.*))?/
    match = regex.match(msg)
    if match[1] != ""
      error = true
      subject = "ERROR: "
    else
      error = false
      subject = ""
    end
    
    match[4].present? ? subject += match[4] : subject = "subject_error"
    
    "[#{timestamp.strftime("%I:%M:%S%p")} JON]   #{msg}\n\n"
  end
end

logfile = File.open("#{Rails.root}/log/custom.log", 'a')  #create log file
logfile.sync = true  #automatically flushes data to file

CUSTOM_LOGGER = CustomLogger.new(logfile)  #constant accessible anywhere
LOG = CUSTOM_LOGGER




