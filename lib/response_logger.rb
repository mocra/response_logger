module ResponseLogger
  def self.included(base)
    base.class_eval do
      alias_method :original_request, :request
      
      def request(req, body = nil, &block)
        # SSL requests will call this method twice if the connection is not started.
        # This is for your own safety.
        if @already_called
          res = original_request(req, body, &block)
        else
          @already_called = true
          file      = Time.now.strftime("%H%M%S")
          file_path = File.join(RAILS_ROOT, "log", Date.today.strftime("%Y/%m/%d"), @port.to_s, @address, req.path.sub(/^\//, ''))

          FileUtils.mkdir_p(file_path)
          res = original_request(req, body, &block)
          File.open(File.join(file_path, file), "w+") do |f|
            f.write(res.body)
          end
        end
        @already_called = false
        res
      end
    end
  end
  
end

require File.join(File.dirname(__FILE__), 'net/http_ext')



