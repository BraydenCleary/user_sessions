# need to make this work and only run it after 'users/:id'
# before() do
#   @messages = {}
# end

before do
  @messages = {}
end

get '/' do
  # Look in app/views/index.erb

  erb :index
end



get '/users' do
  erb :users
end

get '/users/new' do
  erb :users_new
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :users_show
end

post '/signin' do
  if @user = User.find_by_username(params[:username])
    if @user.password == params[:password]
      session[:user_id] = @user.id
      puts session.inspect
      redirect to "/users/#{@user.id}"
    else
      @messages[:error] = "Invalid username or password. Please try again."
      erb :invalid_email_or_password
    end
  else
    @messages[:error] = "Invalid username or password. Please try again."
    erb :invalid_email_or_password
  end
end

get '/signin' do
  erb :signin
end

get '/logout' do
  session[:user_id] = nil
  @messages[:notice] = "You have successfully logged out!"
  erb :logout_confirmation
end

post '/users' do
  if params[:password] == params[:confirm_password]
    @user = User.new(:username => params[:username], 
                      :email => params[:email],
                      :password => params[:password])
    if @user.save
      session[:user_id] = @user.id
      @messages[:notice] = "Welcome, #{@user.username}!"
      redirect to "/users/#{@user.id}"
    else
      @messages[:error] = "Invalid signup, please try again."
      erb :users_new
    end
  else
    @messages[:error] = "Password confirmation doesn't match.  Please try again."
    erb :users_new
  end
end

