require "chunky_png"
require "base64"

payload = File.open(ARGV[0], 'rb').read
base64_payload = Base64.strict_encode64(payload)

puts base64_payload

png = ChunkyPNG::Image.new(1, 1, ChunkyPNG::Color::TRANSPARENT)
png.metadata['payload'] = base64_payload

png.save(ARGV[0] + ".png")