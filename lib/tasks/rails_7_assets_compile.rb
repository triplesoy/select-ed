namespace :assets do
  task :precompile do
    # precompile assets
    system("bundle exec rake assets:precompile")
  end
end
