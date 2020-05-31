import tensorflow as tf
#tf.compat.v1.disable_eager_execution()
import tensorflow.keras as keras

x2=tf.Variable([2.0])

@tf.function
def create(x2):
    x1=tf.constant([1.0])
    sum=tf.add(x1,x2)
    return sum

