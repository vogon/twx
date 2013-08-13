require "chunky_png"
require "base64"

sizes = [256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]

magenta = ChunkyPNG::Color.rgba(255, 0, 255, 255)

sizes.each do |n|
	payload = Random.new.bytes(n)
	base64_payload = Base64.strict_encode64(payload)

	png = ChunkyPNG::Image.new(16, 16, magenta)
	png.metadata['payload'] = base64_payload

	png.save("sizetest-#{n}.png")
end