module Intent
  module Env
    def self.documents_dir
      File.expand_path(ENV['INTENT_DOCUMENTS_DIR'] || "").to_s
    end

    def self.inbox_dir
      ENV['INTENT_INBOX_DIR']
    end

    def self.assets_dir
      ENV['INTENT_ARCHIVE_DIR']
    end

    def self.projects_dir
      ENV['INTENT_PROJECTS_DIR']
    end

    def self.computer_serial
      # macOS: `system_profiler SPHardwareDataType`
      # Win: `wmic bios get serialnumber`
      # Linux: `ls /sys/devices/virtual/dmi/id`
      ENV['INTENT_COMPUTER_SERIAL']
    end
  end
end