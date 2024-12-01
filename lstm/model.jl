using CSV
using DataFrames
using Flux 
using Statistics 

salaries = CSV.read("C:\\Users\\admr0\\Downloads\\salaries.csv", DataFrame)

# for column in names(salaries)
#     missing_count = sum(ismissing(salaries[:, column]))
#     println("column: $column, missing: $missing_count")
# end

job_titles = unique(salaries.job_title)

valid_titles = Set(["ML Engineer", "Machine Learning Engineer", "Machine Learning Scientist", "AI Engineer"])
condition(row) = (row.job_title in valid_titles) && (row.company_location == "US")
ml_salaries = filter(condition, salaries)
select!(ml_salaries, :work_year, :experience_level, :salary_in_usd, :remote_ratio, :company_size)

# grouped_by_xp = groupby(ml_salaries, :experience_level)
# mean_salaries = combine(grouped_by_xp, :salary => mean)
# rename!(mean_salaries, :salary_mean => :salary)

# mean_salaries.salary = Int64.(round.(mean_salaries.salary, digits=0))

xp_encodings = Dict("EN" => 1, "MI" => 2, "SE" => 3, "EX" => 4)
ml_salaries.experience_level = map(category -> xp_encodings[category], ml_salaries.experience_level)

company_size_encodings = Dict("S" => 1, "M" => 2, "L" => 3)
ml_salaries.company_size = map(category -> company_size_encodings[category], ml_salaries.company_size)

normalize(column) = (column .- mean(column)) ./ std(column)

X = hcat(
    normalize(ml_salaries.experience_level),
    normalize(ml_salaries.company_size)
)

y = normalize(ml_salaries.salary_in_usd)

num_rows = size(X)[1]
train_size = Int(floor(0.8 * num_rows))

X_train = X[1:train_size, :]
X_test = X[train_size+1:end, :]

y_train = y[1:train_size, :]
y_test = y[train_size+1:end, :]
 
model = Chain(
    LSTM(2, 50),
    Dense(50, 1), 
    Flux.σ
)

#I run the model with: 
params = Flux.params(model)
opt = Adam()
loss(model, X, y) = sum((model(X) .- y).^2)  # Mean Squared Error

epochs = 300
train_data = [(X_train, y_train)]

for epoch in 1:epochs 
    Flux.train!(loss, params, train_data, opt)

    println("Epoch = $epoch Training Loss = $train_loss")
end 


