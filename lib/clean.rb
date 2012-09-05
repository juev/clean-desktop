class Clean

  def initialize(cf)
    if File.exist?(cf)
      @config = YAML::load_file(cf)
    else
      @config = { "dir" => "~/Desktop",
                  "pictures" =>
                    { "dir" => "~/Pictures", "ext" => [".jpg", ".jpeg", ".gif", ".png"] },
                  "music" =>
                    { "dir" => "~/Music", "ext" => [".mp3", ".flac", ".cue", ".wav", ".wma"] },
                  "documents" =>
                    { "dir" => "~/Documents", "ext" => [".pdf", ".doc", ".docx", ".rtf"] },
                  "other" => "~/Temp"
                }
      File.open(File.expand_path(cf), "w") { |f| f.write(@config.to_yaml) }
    end
  end
  
  def parse
    Dir["#{File.expand_path(@config['dir'])}/*"].each do |fname|
      # puts fname
      if File.file?(fname)
        %w(pictures music documents).each do |item|
          c = @config[item]
          FileUtils.mv(fname, File.expand_path(c['dir'])) if c['ext'].include?(File.extname(fname).downcase)
        end
      else
        h = Hash.new(0)
        fcount = 0
        FileUtils.cd(fname) do
          Dir["**/*"].each do |f|
            h[File.extname(f)] += 1
          end
          fcount = Dir["**/*"].count
        end
        max = h.max_by { |x| x[1] }
        if (max[1].to_f / fcount) < 0.5
          FileUtils.mv(fname, File.expand_path(@config['other']))
        else
          %w(pictures music documents).each do |item|
            c = @config[item]
            FileUtils.mv(fname, File.expand_path(c['dir'])) if c['ext'].include?(max[0].downcase)
          end      
        end        
      end
    end
  end

end