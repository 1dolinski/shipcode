require 'pp'

module ShipCode
  class App < Sinatra::Base
    Tilt.register Tilt::ERBTemplate, 'html.erb'

    enable :sessions

    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['76acb9b121a0b3d163e7d879c3d7dc21250fb4b8'],
      :client_id => ENV['18bfdee362fb0538ece6']
    }

    register Sinatra::Auth::Github

    helpers do
      def repos
        github_request("user/repos")
      end
    end

    get '/' do
      authenticate!
      erb "pages/index".to_sym, :layout => :layout
      # "Hello there, #{github_user.login}!"
    end

    get '/about' do
      erb "pages/about".to_sym, :layout => :layout
    end


    get '/orgs/:id' do
      github_organization_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You have access to the #{params['id']} organization."
    end

    get '/publicized_orgs/:id' do
      github_publicized_organization_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You are publicly a member of the #{params['id']} organization."
    end

    get '/teams/:id' do
      github_team_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You have access to the #{params['id']} team."
    end

    get '/logout' do
      logout!
      redirect 'https://github.com'
    end
  end
end
