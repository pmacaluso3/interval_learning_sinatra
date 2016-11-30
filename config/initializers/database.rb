configure :development do
  set :database, {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: 'your_database_name',
    pool: 2,
    username: 'your_username',
    password: 'your_password'
  }  
end

configure :test do
  
end

configure :production do
  
end
