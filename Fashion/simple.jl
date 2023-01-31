# Dependencies

using Flux, MLDatasets, ProgressMeter
include("TermShow.jl")

# Pull in training data
train_data = FashionMNIST(split=:train)
train_X, train_Y = train_data[:]
categories = train_data.metadata["class_names"]

# Repack category integers into probability matrix
train_Y = Flux.onehotbatch(train_Y, 0:9)

# Build our model - basic model same as MNIST example. Not greatly accurate.
# Input is 28x28 -> 784
# Output is 10
# TODO: Come up with sommething better.
model = Chain(
	Dense(784, 256, relu),
	Dense(256, 10, relu), softmax
)

# Define our loss function
loss(x, y) = Flux.Losses.logitcrossentropy(model(x), y)

# Define optimiser
optimiser = ADAM(0.0001)

# Train our model
epochs = 1000
parameters = Flux.params(model)
_train_data = [(Flux.flatten(train_X),Flux.flatten(train_Y))]
@showprogress for epoch in 1:epochs
	Flux.train!(loss, parameters, _train_data, optimiser)
end

# Test our model.
# Pull in test data
test_data = FashionMNIST(split=:test)
test_X, test_Y = test_data[:]
test_data_ = [(Flux.flatten(test_X), test_Y)]

# Work out accuracy
a_sum_ = 0
for test in 1:length(test_Y)
	guess_ = findmax(model(test_data_[1][1][:, test]))[2]
	correct = test_Y[test] + 1 # off by one errors :(

	if guess_ == correct
		global a_sum_ = a_sum_ + 1
	end 
end
println("Accuracy: ", a_sum_ / length(test_Y))

# Run inference on the first test image which should be "Ankle Boot"
TermShow.render_greyscale_image(test_X[:,:,1])

guess = findmax(model(test_data_[1][1][:, 1]))[2]
println(categories[guess]) 


