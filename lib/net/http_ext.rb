# Override get method to store the files we request.
require 'net/http'
require 'net/https'
module Net
  class HTTP
    include ResponseLogger
  end
end