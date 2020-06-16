import pandas as pd
t="src"
eventclass="DomBasedXss"
classes=pd.read_csv("data/eclipse_orion/wclass/eclipse_orion-{0}.prop.csv".format(t), index_col="URL for pnd")
events=pd.read_csv("data/eclipse_orion/eclipse_orion-eventToReps.prop.csv", index_col="URL for node")
comb=events.join(classes, how="inner")
#print(comb)
print(len(set(comb.index)))
comb.to_csv("data/eclipse_orion/wclass/combined_{0}.csv".format(t))
