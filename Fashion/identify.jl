module identify
	export identify_image

	include("TermShow.jl")

	function identify_image(model, test_X, test_Y, categories, test_number)
		test_image = test_X[:,:,1,test_number]
		test_image_r = reshape(test_image,size(test_image)...,1,1)

		guess = findmax(model(test_image_r))[2][1]
		TermShow.hires_render_greyscale_image(test_image)
		println("Perceived: ", categories[guess], " Actual: ", categories[test_Y[test_number]+1])
	end

end
