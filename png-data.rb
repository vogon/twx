require "chunky_png"
require "base64"

def pack_size_into_color(size)
	if (size > 16777215) then
		fail "can't cope with sizes this big right now"
	end

	r = (size >> 16) & 0xff
	g = (size >> 8) & 0xff
	b = size & 0xff
	ChunkyPNG::Color.rgba(r, g, b, 255)
end

def pack_three(bytes, offset)
	b0, b1, b2 = bytes[offset..(offset + 2)]

	r = b0 ? b0 : 0
	g = b1 ? b1 : 0
	b = b2 ? b2 : 0

	ChunkyPNG::Color.rgba(r, g, b, 255)
end

header_rows = 2

payload = File.open(ARGV[0], 'rb').read
payload_len = payload.length

puts "#{payload_len} bytes to write..."

n_pixels = (payload_len.to_f / 3).ceil

puts "#{n_pixels} pixels..."

edge = (n_pixels ** 0.5).ceil

puts "#{edge}px square..."

png = ChunkyPNG::Image.new(edge, edge + header_rows, ChunkyPNG::Color::BLACK)

# write out length-tagged filename, in red channel only for ease of reco
filename = File.basename(ARGV[0])
filename_bytes = filename.bytes

png[0, 0] = pack_size_into_color(filename_bytes.length)

(0...filename_bytes.length).each do |i|
	png[i + 1, 0] = ChunkyPNG::Color.rgba(filename_bytes[i], 0, 0, 255)
end

# write out payload size
png[0, 1] = pack_size_into_color(payload_len)

payload_bytes = payload.bytes

(0...n_pixels).each do |i|
	if i % 1000 == 0 then
		print "."
	end

	y = i / edge + header_rows
	x = i % edge

	png[x, y] = pack_three(payload_bytes, i * 3)
end

png.save(ARGV[0] + ".png")
