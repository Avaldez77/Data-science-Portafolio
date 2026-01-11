
🔍 **Overview**

This project applies a Transformer-based architecture (DistilBERT) to perform emotion classification on English tweets. It leverages pretrained models and fine-tunes them on task-specific data.

🎯 **Objective**

To build a robust sentiment analysis system capable of detecting six core emotions—anger, fear, joy, love, sadness, and surprise—from short social media texts.

🧠 **Methodology**

- Load and preprocess the `dair-ai/emotion` dataset using Hugging Face `datasets`
- Use `DistilBERT` from `transformers` for sequence classification
- Fine-tune the model on training data using the `Trainer` API
- Evaluate the model on both the original test set and a generalization dataset (`tweet_eval`)
- Perform inference on custom tweet examples

📊 **Key Results**

- Multi-metric evaluation using accuracy, precision, recall, and F1 score
- Demonstrated capability to generalize using mapped emotion classes from a separate dataset

🛠 **Technologies & Skills**

- Python, PyTorch
- Hugging Face Transformers and Datasets
- Text preprocessing, tokenization, fine-tuning, transfer learning
- Evaluation metrics and batch inference

🧩 **Why This Project Matters**

Emotion detection in social media is crucial for applications in marketing, public health, finance, and politics. Leveraging pre-trained Transformers allows high performance with limited data, providing scalable, domain-adaptable solutions.
