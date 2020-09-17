import tensorflow as tf
import numpy as np
import tensorflow_constrained_optimization as tfco
from six.moves import xrange
import math
from MyConstraintedProblem import MyConstraintedProblem

# Create a simulated 10-dimensional training dataset consisting of 1000 labeled
# examples, of which 800 are labeled correctly and 200 are mislabeled.
num_examples = 1000
num_mislabeled_examples = 200
dimension = 10
# We will constrain the recall to be at least 90%.
recall_lower_bound = 0.9

# Create random "ground truth" parameters for a linear model.
ground_truth_weights = np.random.normal(size=dimension) / math.sqrt(dimension)
ground_truth_threshold = 0

# Generate a random set of features for each example.
features = np.random.normal(size=(num_examples, dimension)).astype(
    np.float32) / math.sqrt(dimension)
# Compute the labels from these features given the ground truth linear model.
labels = (np.matmul(features, ground_truth_weights) >
          ground_truth_threshold).astype(np.float32)
# Add noise by randomly flipping num_mislabeled_examples labels.
mislabeled_indices = np.random.choice(
    num_examples, num_mislabeled_examples, replace=False)
labels[mislabeled_indices] = 1 - labels[mislabeled_indices]



# Create variables containing the model parameters.
weights = tf.Variable(tf.zeros(dimension), dtype=tf.float32, name="weights")
threshold = tf.Variable(0.0, dtype=tf.float32, name="threshold")

# Create the optimization problem.
constant_labels = tf.constant(labels, dtype=tf.float32)
constant_features = tf.constant(features, dtype=tf.float32)

def predictions():
  return tf.tensordot(constant_features, weights, axes=(1, 0)) - threshold

def getweights():
    return weights
# Like the predictions, in eager mode, the labels should be a nullary function
# returning a Tensor. In graph mode, you can drop the lambda.
# context = tfco.rate_context(predictions, labels=lambda: constant_labels)
# problem = tfco.RateMinimizationProblem(
#     tfco.error_rate(context), [tfco.recall(context) >= recall_lower_bound, ])

problem = MyConstraintedProblem(
    labels=constant_labels,
    predictions=predictions,
    weights=getweights
)


def average_hinge_loss(labels, predictions):
  # Recall that the labels are binary (0 or 1).
  signed_labels = (labels * 2) - 1
  return np.mean(np.maximum(0.0, 1.0 - signed_labels * predictions))

def recall(labels, predictions):
  # Recall that the labels are binary (0 or 1).
  positive_count = np.sum(labels)
  true_positives = labels * (predictions > 0)
  true_positive_count = np.sum(true_positives)
  return true_positive_count / positive_count

# ProxyLagrangianOptimizerV2 is based on tf.keras.optimizers.Optimizer.
# ProxyLagrangianOptimizerV1 (which we do not use here) would work equally well,
# but is based on the older tf.compat.v1.train.Optimizer.
optimizer = tfco.ProxyLagrangianOptimizerV2(
    optimizer=tf.keras.optimizers.Adagrad(learning_rate=1.0),
    num_constraints=problem.num_constraints)

# In addition to the model parameters (weights and threshold), we also need to
# optimize over any trainable variables associated with the problem (e.g.
# implicit slack variables and weight denominators), and those associated with
# the optimizer (the analogues of the Lagrange multipliers used by the
# proxy-Lagrangian formulation).
var_list = ([weights, threshold] + problem.trainable_variables +
            optimizer.trainable_variables())


for ii in xrange(2000):
  optimizer.minimize(problem, var_list=var_list)

trained_weights = weights.numpy()
trained_threshold = threshold.numpy()

trained_predictions = np.matmul(features, trained_weights) - trained_threshold
print("Constrained average hinge loss = %f" % average_hinge_loss(
    labels, trained_predictions))
print("Constrained recall = %f" % recall(labels, trained_predictions))
print("Weights: ", trained_weights)
#
# optimizer = tf.keras.optimizers.Adagrad(learning_rate=1.0)
# var_list = [weights, threshold]
#
# for ii in xrange(1000):
#   # For optimizing the unconstrained problem, we just minimize the "objective"
#   # portion of the minimization problem.
#   optimizer.minimize(problem.objective, var_list=var_list)
#
# trained_weights = weights.numpy()
# trained_threshold = threshold.numpy()
#
# trained_predictions = np.matmul(features, trained_weights) - trained_threshold
# print("Unconstrained average hinge loss = %f" % average_hinge_loss(
#     labels, trained_predictions))
# print("Unconstrained recall = %f" % recall(labels, trained_predictions))