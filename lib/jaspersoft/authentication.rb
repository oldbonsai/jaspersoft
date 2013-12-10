module Jaspersoft
  
  module Authentication
    
    def basic_authenticated?
      !!(username && password)
    end
    
    def session_authenticated?
      !!(session)
    end
    
    def user_authenticated?
      basic_authenticated? || token_authenticated?
    end
    
    def login
      if session_authenticated?
        authenticate_with_session
      else
        authenticate_with_basic
      end
    end
    
    private
    
    def authenticate_with_basic
      basic_agent = new_agent{ |http| http.basic_auth(username, password) }
      response = basic_agent.call(:post, URI.encode("#{ endpoint_url(v2: false) }/login/".to_s), { content_type: "application/x-www-form-urlencoded", j_username: username, j_password: password })

      if response && response.status == 200 && response.headers["set-cookie"] != ""
        self.session = response.headers["set-cookie"].match(/jsessionid=(.+?);/i)[1]
        authenticate_with_session
      else
        raise AuthenticationError
      end
    end
    
    def authenticate_with_session
      @agent = new_agent{ |http| http.headers[:Cookie] = "$Version=0; JSESSIONID=#{session}; $Path=/jasperserver" }
    end
    
  end
  
end