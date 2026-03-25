import tensorflow as tf
import numpy as np

# AI Diet Planner - TFLite Regression Model
# ----------------------------------------
# This model predicts the optimal daily calorie adjustment (delta) based on:
# 1. Current Weight (kg)
# 2. Daily Logged Calories (kcal)
# 3. Body Type (0 = Lean, 1 = Fit, 2 = Fat)
# 4. Consistency (Days logged consecutively)
#
# Goal:
# - Lean: Output slight positive delta (+50 to +200) to encourage healthy bulking.
# - Fit: Output ~0 delta to maintain balance.
# - Fat: Output slight negative delta (-50 to -200) to encourage healthy deficit.

# 1. Generate Dummy Dataset
num_samples = 1000

# Random inputs
weights = np.random.uniform(50.0, 120.0, num_samples).astype(np.float32)
logged_calories = np.random.uniform(1200.0, 3500.0, num_samples).astype(np.float32)
body_types = np.random.randint(0, 3, num_samples).astype(np.float32) # 0=Lean, 1=Fit, 2=Fat
days_logged = np.random.randint(0, 30, num_samples).astype(np.float32)

x_train = np.stack([weights, logged_calories, body_types, days_logged], axis=1)

# Generate Labels (Target Calorie Delta) based on Body Type Rules
y_train = np.zeros(num_samples, dtype=np.float32)

for i in range(num_samples):
    b_type = body_types[i]
    if b_type == 0: # Lean -> Needs Surplus
        y_train[i] = np.random.uniform(50.0, 150.0)
    elif b_type == 1: # Fit -> Maintenance
        y_train[i] = np.random.uniform(-20.0, 20.0)
    else: # Fat -> Deficit
        y_train[i] = np.random.uniform(-150.0, -50.0)

# Normalize inputs for training stability
mean = x_train.mean(axis=0)
std = x_train.std(axis=0) + 1e-7
x_train_norm = (x_train - mean) / std

# 2. Build the Neural Network Model
model = tf.keras.Sequential([
    tf.keras.layers.Dense(16, activation='relu', input_shape=(4,)),
    tf.keras.layers.Dense(8, activation='relu'),
    tf.keras.layers.Dense(1) # Linear output (Calorie Delta)
])

model.compile(optimizer='adam', loss='mse', metrics=['mae'])

# 3. Train the Model
print("Training Diet TFLite Model...")
model.fit(x_train_norm, y_train, epochs=20, batch_size=32, verbose=1)

# 4. Convert to TFLite format
# Note: In production, you would embed normalization params into the model or pass them to Dart.
# For simplicity, we are passing the raw TFLite format.
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# 5. Save the TFLite model to Flutter assets
output_path = '../assets/diet_model.tflite'
with open(output_path, 'wb') as f:
    f.write(tflite_model)

print(f"\n✅ Diet TFLite model successfully saved to '{output_path}'")
