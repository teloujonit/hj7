def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

desc "generate website in output directory"
task :default => :generate_site do
  puts ">>> Site Generating Complete! <<<\n\n"
end

desc "remove files in output directory"
task :clean do
  puts ">>> Removing output <<<"
  Dir["_site/*"].each { |f| rm_rf(f) }
end

desc "Generate site files only"
task :generate_site => :clean do
  puts "\n\n>>> Generating site files <<<"
  ENV['JEKYLL_ENV'] = 'production'
  system "jekyll --no-server --no-auto --no-future"
end

# usage rake post[my-new-post] or rake post['my new post'] or rake post (defaults to "new-post")
desc "Begin a new post in _posts"
task :post, :filename do |t, args|
  args.with_defaults(:filename => 'new-post')
  time  = Time.now.strftime('%Y-%m-%d_%H-%M')
  system "touch _posts/#{time}-#{args.filename}.md"
end

# usage rake post[my-new-post] or rake post['my new post'] or rake post (defaults to "new-post")
desc "Begin a new post in _drafts"
task :draft, :filename do |t, args|
  args.with_defaults(:filename => 'new-post')
  time  = Time.now.strftime('%Y-%m-%d_%H-%M')
  system "touch _drafts/#{time}-#{args.filename}.md"
end

desc "start development server"
task :server do
  system "bundle exec jekyll --server"
end

desc "watch the project for changes"
task :watch do
  system "bundle exec jekyll"
end
