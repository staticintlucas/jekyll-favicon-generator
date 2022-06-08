# frozen_string_literal: true

require "fileutils"
require "open3"

module JekyllSvgFavicons
  class Inkscape
    include JekyllSvgFavicons

    def initialize(path = nil)
      abort_with "Inkscape not found in '#{path}'" if path && !(exe? path)

      @exe = path || find
      abort_with "Inkscape not found on PATH" unless @exe
      debug "Using Inkscape from #{@exe}"

      @version = version
      abort_with "Cannot determine Inkscape version" unless @version
      debug "Detected Inkscape version #{@version[:major]}.#{@version[:minor]}"

      open_shell
      quit
    end

    def find
      find_in_path || find_common_locations
    end

    def version
      stdin, stdout = Open3.popen2e @exe, "--version", :chdir => File.dirname(@exe)
      while (line = stdout.gets)
        m = line.match(%r!^Inkscape (?<major>\d+)\.(?<minor>\d+)!)
        break if m
      end
      while stdout.gets do end
      stdin.close
      stdout.close
      m.named_captures.transform_keys(&:to_sym).transform_values(&:to_i)
    end

    def quit
      ready_count = 0
      @stdin.close # Inkscape should exit for EOF on stdin
      unless @stdout.closed?
        # Wait for EOF on stdout
        while read_stdout != :eof
          ready_count += 1
          next unless ready_count >= 3

          warn "Inkscape not responding to EOF... killing Inkscape"
          Process.kill "KILL", @wait_thr.pid
          break
        end
        @stdout.close
      end
      exitstatus = @wait_thr.value.exitstatus
      warn "Inkscape quit with exit code #{exitstatus}" if exitstatus.nonzero?
    end

    def self.finalize(obj)
      proc { obj.quit }
    end

    private

    def find_in_path
      # Try to find inkscape on the path first
      path = ENV["PATH"].split File::PATH_SEPARATOR
      exts = ENV["PATHEXT"] ? ENV["PATHEXT"].split(File::PATH_SEPARATOR) : [""]
      files = path.product(exts).map! { |pth, ext| File.join pth, "inkscape#{ext}" }
      files.find { |f| exe? f }
    end

    def find_common_locations
      # Windows paths
      locs = ["Program Files", "Program Files (x86)"].product(["bin", ""]).map! do |pf, dir|
        File.join "C:", pf, "Inkscape", dir, "inkscape.exe"
      end
      # Mac paths
      locs += ["MacOS", "Resources/bin"].map! do |dir|
        File.join "/Applications/Inkscape.app/Contents", dir, "inkscape"
      end
      locs.find { |f| exe? f }
    end

    def exe?(file)
      File.executable?(file) && !File.directory?(file)
    end

    def running?
      if @wait_thr
        begin
          Process.getpgid @wait_thr.pid
          true
        rescue Errno::ESRCH
          false
        end
      else
        false
      end
    end

    def open_shell
      @stdin, @stdout, @wait_thr = Open3.popen2e @exe, "--shell", :chdir => File.dirname(@exe)
      ObjectSpace.define_finalizer self, self.class.finalize(self)
      wait_for_ready
    end

    def wait_for_ready
      case read_stdout
      when :ready
        # return
      when :eof
        abort_with "Inkscape unexpectedly quit with exit code #{@wait_thr.value.exitstatus}"
      else
        abort_with "Program shouldn't ever get here!?"
      end
    end

    def read_stdout
      while (c = @stdout.getc)
        case c
        when ">"
          return :ready
        when "\n", " "
          # Skip empty lines and leading whitespace
        else
          line = "#{c}#{@stdout.gets}"
          # Filter out those anoying dbus errors
          debug "inkscape:", line unless %r!CRITICAL.+dbus_g_.+assertion!.match?(line)
        end
      end
      :eof
    end

    def send_command(cmd)
      @stdin.puts cmd
      debug "inkscape>", cmd.to_s
    end
  end
end
