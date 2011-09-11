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

desc 'generate and deploy website via fog'
task :deploy => :default do
  puts '>>> DEPLOYING SITE <<<'

  configs = YAML::load_file('_fog.yml')

  src    = File.expand_path('_site')
  bucket = configs.delete(:bucket) || configs.delete(:bucket_name)
  path   = nil

  puts 'Connecting'
  connection = ::Fog::Storage.new(configs)

  # Get bucket
  puts 'Getting bucket'
  begin
    directory = connection.directories.get(bucket)
  rescue ::Excon::Errors::NotFound
    should_create_bucket = true
  end
  should_create_bucket = true if directory.nil?

  # Create bucket if necessary
  if should_create_bucket
    directory = connection.directories.create(key: bucket)
  end

  # Get list of remote files
  files = directory.files
  truncated = files.respond_to?(:is_truncated) && files.is_truncated
  while truncated
    set = directory.files.all(marker: files.last.key)
    truncated = set.is_truncated
    files = files + set
  end

  # Delete all the files in the bucket
  puts 'Removing remote files'
  files.all.each do |file|
    file.destroy
  end

  # Upload all the files in the output folder to the clouds
  puts 'Uploading local files'
  FileUtils.cd(src) do
    files = Dir['**/*'].select { |f| File.file?(f) }
    files.each do |file_path|
      directory.files.create(
        key: "#{path}#{file_path}",
        body: File.open(file_path),
        public: true)
    end
  end

  puts 'Done!'
end
