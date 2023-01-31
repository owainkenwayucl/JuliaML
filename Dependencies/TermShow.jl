# Render a Greyscale image using xterm 256color colours
# I did *try* to use Crayons.jl but that breaks in screen while this doesn't.
# Owain Kenway

module TermShow

	export render_greyscale_image

	function render_greyscale_image(image)
		num_colours = 25 
		base_colour = 231
		colours_int = fill(base_colour, num_colours)
		pixels = fill(" ", num_colours)
		for a in 1:num_colours-1 # every colour except the last one
			colours_int[a] = base_colour + a
		end

		for a in 1:num_colours
       			pixels[a] = "\033[48;5:"*string(colours_int[a])*"m  \033[m"
		end

		dimensions = size(image)

		width = dimensions[2]
		height = dimensions[1]

		for y in 1:height
			for x in 1:width
				index = Int(floor(image[x,y] * (num_colours-1))) + 1
				print(pixels[index])
			end
			println("")
		end
	end

end
