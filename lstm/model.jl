using Flux
using Plots
using Random 

# Generate sine wave data
function generate_sine_wave(seq_length, num_samples)
    x = range(0, num_samples * π, length=seq_length * num_samples)
    y = sin.(x)
    return y
end

# Parameters
seq_length = 50  # Length of input sequence
num_samples = 100  # Number of samples

# Create data
data = generate_sine_wave(seq_length, num_samples)

# Visualize the sine wave
plot(data[1:seq_length * 2], title="Sine Wave", label="Sine Wave", xlabel="Index", ylabel="Value")


# Create sequences and targets
function create_sequences(data, seq_length)
    X, y = [], []

    for i in 1:(length(data) - seq_length)
        push!(X, data[i:i+seq_length-1])
        push!(y, data[i+seq_length])
    end

    return hcat(X...)', y
end

X, y = create_sequences(data, seq_length)

# Convert to Float32
X = Float32.(X)
y = Float32.(y)

# Split into training and test sets
train_size = Int(floor(0.8 * size(X, 1)))
X_train, X_test = X[1:train_size, :], X[train_size+1:end, :]
y_train, y_test = y[1:train_size], y[train_size+1:end]

model = Chain(
    LSTM(seq_length, 64),
    Dense(64, 1)
)

Flux.reset!(model)

loss(x, y) = Flux.mse(model(x'), y)

opt = Descent(0.01)

# Prepare training loop
epochs = 100
batch_size = 32

# Training loop
for epoch in 1:epochs
    
    for i in 1:batch_size:train_size 
        batch_X = X_train[i:min(i+batch_size-1, train_size), :]
        batch_y = y_train[i:min(i+batch_size-1, train_size)]

        gs = Flux.gradient(() -> loss(batch_X, batch_y), Flux.params(model))
        Flux.Optimise.update!(opt, Flux.params(model), gs)
    end
    
    # Print loss every 10 epochs
    if epoch % 10 == 0
        train_loss = loss(X_train', y_train)
        println("Epoch $epoch, Loss: $train_loss")
    end
end