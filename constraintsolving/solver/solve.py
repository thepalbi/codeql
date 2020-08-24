import os
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
import tensorflow as tf
import tensorflow_constrained_optimization as tfco
from MyConstraintedProblem import TaintSpecConstraints
from six.moves import xrange
import numpy as np
# create variables
#tf.compat.v1.disable_eager_execution()


vars=dict()
vars_to_train=[]
totalvars=0
with open("var.txt") as varsfile:
    for line in varsfile.readlines():
        parts=line.split(":")
        # if parts[1] == "constant":
        #     v = tf.constant(float(parts[2]), name=parts[0], dtype=tf.float32)
        # else:
        v = tf.Variable(tf.constant(np.random.uniform(0,1), dtype=tf.float32), name=parts[0])
        totalvars+=1
        vars_to_train.append(v)
        vars[parts[0]] = v

print("Created {0} variables".format(len(vars.keys())))
problem=TaintSpecConstraints(variables=vars)

optimizer = tfco.ProxyLagrangianOptimizerV2(
    optimizer=tf.keras.optimizers.Adagrad(learning_rate=0.5),
    num_constraints=problem.num_constraints)


var_list = (vars_to_train + problem.trainable_variables +
            optimizer.trainable_variables())

for ii in xrange(10):
    print("iteration : %d" % ii)
    optimizer.minimize(problem, var_list=var_list)
    # clamp the values
    for v in vars_to_train:
        v.assign(max(v, tf.constant([0.0])))
        v.assign(min(tf.constant([1.0]), v))


#print("Final loss: {0}".format(problem.objective()))
with open("results.txt", "w") as resultsfile:
    for v in vars.keys():
        print("{0}:{1}".format(v, vars[v].numpy()))
        resultsfile.write("{0}:{1}\n".format(v, vars[v].numpy()))






