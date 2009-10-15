= response_logger

Require this little gem (tee hee) into your application's environment and all requests made via Net::HTTP are logged into the log folder. This works with ActiveResource, Mechanize, Nokogiri and HTTParty.

Include it into your rails app like so:

    config.gem 'response_logger'

And restart your rails server to load it in.
    
The next time you make a Net::HTTP request a folder will appear in the log folder like this:

    <year>
      \_<month>
         \_<day>
            \_<port number>
               \_<domain>
                  \_<path>
                     \_<to>
                        \_<file>
                           \_<hour><minute><second>

The final file in that chain contains the response body.

== Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

== Copyright

Copyright (c) 2009 Ryan Bigg. See LICENSE for details.
