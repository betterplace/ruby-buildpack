require 'open-uri'

module LanguagePack::Betterplace
  def run_assets_precompile_rake_task
    Dir.chdir('public') do
      asset_bucket = ENV.fetch('OUTSIDE_ASSET_BUCKET')
      sha          = ENV.fetch('SOURCE_VERSION')
      filename     = 'manifests.tar.gz'
      url          = 'https://storage.googleapis.com/%s/%s-%s' % [
        asset_bucket, filename, sha
      ]
      manifests =
        begin
          URI.open(url).read
        rescue => e
          raise e, "Caught #{e.class} fetching #{url}: #{e}"
        end
      File.open(filename, 'wb') do |output|
        output.write manifests
      end
      system "tar xzf #{filename.inspect}" or raise "Couldn't untar #{filename.inspect}!"
    end
  end
end
