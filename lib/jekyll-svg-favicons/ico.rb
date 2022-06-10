# frozen_string_literal: true

require "vips"
require "bit-struct"

module JekyllSvgFavicons
  module Ico
    BYTE = 8
    WORD = 2 * BYTE
    DWORD = 4 * BYTE
    LONG = 4 * BYTE
    BPP_COUNT = 32

    def img_to_ico(svg, ico, sizes)
      File.open(ico, "wb") do |f|
        f.write icon_dir sizes

        sizes.each do |size|
          f.write bitmap_info_header size
          f.write bitmap_pixel_array svg, size
        end
      end
    end

    # Generate the ICONDIR structure for the ICO file
    def icon_dir(sizes)
      count = sizes.length
      offset = IconDir.round_byte_length + count * IconDirEntry.round_byte_length

      dir = IconDir.new.tap do |id|
        id.type     = 1 # 1 => ICO
        id.count_   = count
      end.to_s

      entries = sizes.map do |size|
        entry, bytes = icon_dir_entry size, offset
        offset += bytes
        entry
      end

      dir + entries.join
    end

    def icon_dir_entry(size, offset)
      rowsize = (size * BPP_COUNT + 31) / 32 * 4
      bytes = rowsize * size + 40

      entry = IconDirEntry.new.tap do |ide|
        ide.width         = size
        ide.height        = size
        ide.color_count   = 0 # 0 => no color palette
        ide.planes        = 1
        ide.bit_count     = BPP_COUNT
        ide.bytes_in_res  = bytes
        ide.image_offset  = offset
      end

      [entry.to_s, bytes]
    end

    def bitmap_info_header(size)
      BitMapInfoHeader.new.tap do |bih|
        bih.size_ = BitMapInfoHeader.round_byte_length # size is only the header size
        bih.width = size
        bih.height = 2 * size # must be double height, even if no AND mask is included
        bih.planes = 1
        bih.bit_count = BPP_COUNT
        bih.compression = 0 # 0 => none
        bih.size_image = size * size * BPP_COUNT
        bih.x_pels_per_meter = 3780
        bih.y_pels_per_meter = 3780
        bih.clr_used = 0 # 0 since we don't use a palette
        bih.clr_important = 0 # 0 important colors - ignored by most implementations
      end
    end

    def bitmap_pixel_array(svg, size)
      img = Vips::Image.thumbnail svg, size, :height => size
      img = img.flip(:vertical) # Flip the image since bitmap is stored bottom to top

      # Colors are stored in ARGB format with LE order, so BGRA
      arr = img.to_enum.map { |row| row.map { |(r, g, b, a)| [b, g, r, a] } }
      arr.flatten.pack("C*")
    end

    class IconDir < BitStruct
      default_options :endian => :little

      pad      :reserved, WORD
      unsigned :type,     WORD
      unsigned :count_,   WORD
    end

    class IconDirEntry < BitStruct
      default_options :endian => :little

      unsigned :width,        BYTE
      unsigned :height,       BYTE
      unsigned :color_count,  BYTE
      pad      :reserved,     BYTE
      unsigned :planes,       WORD
      unsigned :bit_count,    WORD
      unsigned :bytes_in_res, DWORD
      unsigned :image_offset, DWORD
    end

    class BitMapInfoHeader < BitStruct
      default_options :endian => :little

      unsigned :size_,            DWORD
      signed   :width,            LONG
      signed   :height,           LONG
      unsigned :planes,           WORD
      unsigned :bit_count,        WORD
      unsigned :compression,      DWORD
      unsigned :size_image,       DWORD
      signed   :x_pels_per_meter, LONG
      signed   :y_pels_per_meter, LONG
      unsigned :clr_used,         DWORD
      unsigned :clr_important,    DWORD
    end
  end
end
