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

      open_shell!
      quit!
    end

    def find
      find_in_path || find_common_locations
    end

    def version
      _stdin, stdout = Open3.popen2e @exe, "--version", :chdir => File.dirname(@exe)
      while (line = stdout.gets)
        m = line.match(%r!^Inkscape (?<major>\d+)\.(?<minor>\d+)!)
        return m.named_captures.transform_keys(&:to_sym).transform_values(&:to_i) if m
      end
    end

    def self.finalize
      proc do
        @stdin.close if @stdin && !@stdin.closed?
        @stdout.close if @stdout && !@stdout.closed?
      end
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

    def open_shell!
      @stdin, @stdout, @wait_thr = Open3.popen2e @exe, "--shell", :chdir => File.dirname(@exe)
      ObjectSpace.define_finalizer self, self.class.finalize
      wait_for_ready!
    end

    def wait_for_ready!
      loop do
        case (c = @stdout.getc)
        when nil
          abort_with "Inkscape unexpectedly quit with exit code #{@wait_thr.value.exitstatus}"
        when ">"
          return
        else
          debug "inkscape: #{c}#{@stdout.gets}" unless c == "\n"
        end
      end
    end

    def send_command!(cmd)
      @stdin.puts cmd
      debug "inkscape> #{cmd}"
    end

    def quit!
      send_command! "quit"

      loop do
        case (c = @stdout.getc)
        when nil
          if @wait_thr.value.exitstatus.nonzero?
            warn "Inkscape quit with exit code #{@wait_thr.value.exitstatus}"
          end
          break
        when ">"
          warn "Inkscape not responding to quit... killing Inkscape"
          Process.kill "KILL", @wait_thr.pid
        else
          debug "inkscape: #{c}#{@stdout.gets}" unless c == "\n"
        end
      end
    end
  end
end
