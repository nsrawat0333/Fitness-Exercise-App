import tensorflow as tf
import numpy as np
import os
import argparse

def create_and_train_model():
    print("--------------------------------------------------")
    print("🚀 FITNESS PLANNER TFLITE MODEL GENERATOR 🚀")
    print("--------------------------------------------------")
    
    # Define a simple lightweight Regression model
    # Inputs:
    # 0: current_reps (float)
    # 1: current_sets (float)
    # 2: consecutive_days_logged (float)
    # Outputs:
    # 0: predicted_next_reps (float)
    # 1: predicted_next_sets (float)
    
    model = tf.keras.Sequential([
        tf.keras.layers.InputLayer(input_shape=(3,), name="workout_history_input"),
        tf.keras.layers.Dense(16, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(0.01)),
        tf.keras.layers.Dense(8, activation='relu'),
        # Output layer with 2 neurons (reps, sets)
        tf.keras.layers.Dense(2, activation='linear', name="progressive_overload_output")
    ])
    
    model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=0.01),
                  loss='mse',
                  metrics=['mae'])
    
    # ----------------------------------------------------
    # GENERATE SYNTHETIC TRAINING DATA (Progressive Overload)
    # ----------------------------------------------------
    # We want the model to learn that if a user is consistent, they should slightly increase reps.
    # Current Reps, Current Sets, Consecutive Days -> Target Reps, Target Sets
    
    # Example 1: Consistent user (many days) -> Increase reps slightly
    # [10 reps, 3 sets, 5 days logged] -> [12 reps, 3 sets]
    # Example 2: Inconsistent user (few days) -> Maintain or drop slightly
    # [10 reps, 3 sets, 1 day logged] -> [10 reps, 3 sets]
    
    X_train = np.array([
        [10.0, 3.0, 5.0],
        [10.0, 3.0, 1.0],
        [15.0, 3.0, 7.0],
        [15.0, 4.0, 2.0],
        [5.0,  5.0, 10.0],
        [8.0,  3.0, 0.0],
        [12.0, 4.0, 14.0],
        [20.0, 3.0, 3.0]
    ], dtype=np.float32)
    
    y_train = np.array([
        [12.0, 3.0], # Progressive rep increase
        [10.0, 3.0], # Maintain
        [17.0, 3.0], # Progressive rep increase
        [15.0, 4.0], # Maintain
        [6.0,  5.0], # Slight rep increase
        [8.0,  3.0], # Maintain
        [14.0, 4.0], # Progressive rep increase
        [21.0, 3.0]  # Slight rep increase
    ], dtype=np.float32)
    
    print("\n🏋️ Training Lightweight Regression Model...")
    model.fit(X_train, y_train, epochs=200, verbose=0)
    print("✅ Training Complete.")
    
    # Evaluate a test case
    test_case = np.array([[10.0, 3.0, 7.0]], dtype=np.float32)
    prediction = model.predict(test_case, verbose=0)
    print(f"\nTest Prediction for [10 reps, 3 sets, 7 days logged]:")
    print(f"Predicted Next: {prediction[0][0]:.1f} reps, {prediction[0][1]:.1f} sets")
    
    # ----------------------------------------------------
    # EXPORT TO TFLITE
    # ----------------------------------------------------
    print("\n📦 Converting to TensorFlow Lite...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    # Optimize for mobile (reduce size without losing significant accuracy)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()
    
    # Save the model
    output_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "assets", "planner_model.tflite")
    
    with open(output_path, "wb") as f:
        f.write(tflite_model)
        
    print(f"✅ TFLite Model saved successfully at: {output_path}")
    print(f"Size: {len(tflite_model)} bytes")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Train lightweight planner TFLite model.")
    args = parser.parse_args()
    
    create_and_train_model()
