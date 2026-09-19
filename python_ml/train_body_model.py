import os
import argparse
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.models import Model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import numpy as np

# Define classes
CLASSES = ["Lean", "Fit", "Fat"]
IMG_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS = 20

def create_model(num_classes):
    """Creates a MobileNetV2 based transfer-learning model."""
    base_model = MobileNetV2(
        weights='imagenet', 
        include_top=False, 
        input_shape=(IMG_SIZE[0], IMG_SIZE[1], 3)
    )
    
    # Freeze the base model for initial training
    base_model.trainable = False
    
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    x = Dropout(0.2)(x)
    x = Dense(128, activation='relu')(x)
    predictions = Dense(num_classes, activation='softmax')(x)
    
    model = Model(inputs=base_model.input, outputs=predictions)
    
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    return model

def train_real_model(dataset_path, export_path):
    """Trains the model using real images from the dataset path."""
    print(f"Loading dataset from {dataset_path}...")
    
    datagen = ImageDataGenerator(
        rescale=1./255, # Normalize to [0, 1]. tflite_flutter handles mapping to [-1, 1] if needed, but [0,1] is fine.
        validation_split=0.2, # 80/20 train/val split
        rotation_range=20,
        width_shift_range=0.2,
        height_shift_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest'
    )

    train_generator = datagen.flow_from_directory(
        dataset_path,
        target_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        subset='training'
    )

    val_generator = datagen.flow_from_directory(
        dataset_path,
        target_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        subset='validation'
    )
    
    model = create_model(len(CLASSES))
    
    print("Starting training...")
    model.fit(
        train_generator,
        validation_data=val_generator,
        epochs=EPOCHS
    )
    
    # Save model
    export_tflite(model, export_path)

def generate_dummy_model(export_path):
    """Generates an untrained structurally valid model for immediate Flutter integration testing."""
    print("Generating a structurally valid (but untrained) TFLite model for Flutter UI testing...")
    model = create_model(len(CLASSES))
    
    # Push 1 dummy batch through to compile the graph fully
    dummy_input = np.random.rand(1, 224, 224, 3).astype(np.float32)
    model.predict(dummy_input)
    
    export_tflite(model, export_path)

def export_tflite(model, export_path):
    print(f"Converting model to TFLite format at {export_path}...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    # Enable mobile optimizations
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()
    
    # Ensure directory exists
    os.makedirs(os.path.dirname(export_path), exist_ok=True)
    
    with open(export_path, 'wb') as f:
        f.write(tflite_model)
    print("TFLite model successfully exported!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Body Classification CNN Training Script")
    parser.add_argument("--dataset", type=str, help="Path to the kaggle dataset folder (must contain subfolders 'Lean', 'Fit', 'Fat')")
    parser.add_argument("--export", type=str, default="../assets/model.tflite", help="Path to save the generated .tflite file")
    parser.add_argument("--dummy", action='store_true', help="Generate a dummy model without training data")
    
    args = parser.parse_args()
    if args.dummy:
        generate_dummy_model(args.export)
    elif args.dataset:
        if not os.path.exists(args.dataset):
            print(f"Error: Dataset path '{args.dataset}' does not exist.")
        else:
            train_real_model(args.dataset, args.export)
    else:
        print("Please provide either --dataset <path> or use --dummy to generate a quick test model.")
        print("Example: python3 train_body_model.py --dummy")
