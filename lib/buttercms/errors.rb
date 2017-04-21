module ButterCMS
  # Error is the top level error raised by ButterCMS
  class Error < StandardError
  end

  # NotFound is raised when a resource cannot be found
  class NotFound < Error
  end
end
