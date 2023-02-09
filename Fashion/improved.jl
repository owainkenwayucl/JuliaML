# Dependencies

using Flux, MLDatasets, ProgressMeter, MLUtils

include("TermShow.jl")

# Pull in training data
train_data = FashionMNIST(split=:train)
train_X, train_Y = train_data[:]
categories = train_data.metadata["class_names"]

train_X = MLUtils.unsqueeze(train_X,3)
train_Y = Flux.onehotbatch(train_Y, 0:(length(categories)-1))

# Build model
model = Chain(
	Conv((5, 5), 1=>6, relu),
	MaxPool((2, 2)),
	Conv((5, 5), 6=>16, relu),
	MaxPool((2, 2)),
	Flux.flatten,
	Dense(prod((4, 4, 16)), 120, relu), 
	Dense(120, 84, relu), 
	Dense(84, length(categories))
)

# Define our loss function
loss(x, y) = Flux.Losses.logitcrossentropy(model(x), y)

# Define optimiser
optimiser = ADAM()

# Train our model
epochs = 40
println("Training with ", epochs, " epochs...")
parameters = Flux.params(model)
_train_data = [(train_X,train_Y)]
@showprogress for epoch in 1:epochs
	Flux.train!(loss, parameters, _train_data, optimiser)
end

println("Testing model...")

# Pull in test data
test_data = FashionMNIST(split=:test)
test_X, test_Y = test_data[:]
test_X = MLUtils.unsqueeze(test_X,3)

# Work out accuracy
a_sum_ = 0
for test in 1:length(test_Y)
	temp_image_ = test_X[:,:,1,test]
	temp_image_r = reshape(temp_image_, size(temp_image_)...,1,1)
	guess_ = findmax(model(temp_image_r))[2][1]
	correct = test_Y[test] + 1 # off by one errors :(
	if guess_ == correct
		global a_sum_ = a_sum_ + 1
	end 
end
println("Accuracy: ", a_sum_ / length(test_Y))

# Run inference on the first test image which should be "Ankle Boot"
temp_image_ = test_X[:,:,1,1]
temp_image_r = reshape(temp_image_, size(temp_image_)...,1,1)

TermShow.hires_render_greyscale_image(temp_image_r)

guess = findmax(model(temp_image_r))[2]
println("This should be an 'Ankle boot': ",categories[guess]) 

