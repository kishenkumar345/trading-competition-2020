# The purpose of this module is to manage environment variables

class Config 

  # Place in memory to store the env variables
  def initialize
    @hash = {}
  end
  # This function can be used to build a config object off a file_name
  def self.build(file_name)
    c = Config.new
    c.load_file(file_name)
  end
  # Do the business, actually load a .env file into memory
  def load_file(file_name)
    File.foreach(file_name) do |line| 
      next if line.strip.chomp.size == 0
      next if line.strip.chomp[0] == "#"
      
      (key, value) = line.split("=").map { |s| s.strip.chomp }
      @hash[key] = value
    end
    self
  end
  # Merge another config object with this one, will overwrite any matched keys
  def merge(other_config)
    other_config.hash.each { |key, value| 
      @hash[key] = value 
    }
  end
  # Getters and setters
  def hash 
    @hash
  end

  def get(key)
    @hash[key]
  end

  def change(key, value)
    @hash[key] = value
  end

  def to_s
    @hash.map { |key, value| 
      "#{key}:".ljust(30) + "#{value}"
    }.join("\n")
  end

end