# frozen_string_literal: true

module JekyllFaviconGenerator
  class Size
    def initialize(size_str)
      @size_arr = size_str.split(",").map(&:to_i)
      @size_arr.reject!(&:zero?)
      @size_arr = [16] if @size_arr.nil? || @size_arr.empty?
    end

    def to_a
      @size_arr
    end

    def to_i
      @size_arr[0]
    end

    def to_s
      @size_arr.map { |s| "#{s}x#{s}" }.join " "
    end
  end
end
