module CustomExceptions
  class InvalidPrefecture < StandardError
  end
  rescue_from InvalidPrefecture do |exception|
    redirect_to hello_work_agencies_path, alert: exception.message
  end
end