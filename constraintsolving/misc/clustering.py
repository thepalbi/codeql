import pandas as pd
from pygments.lexer import default
from sklearn.metrics import precision_score, recall_score, f1_score
from glob import glob
import warnings
warnings.filterwarnings("ignore")

files=glob('results/*/NoSqlInjection-0.45/*nf.prop.csv', recursive=True)
threshold = 0.0
t='-snk-'

total=0
t_known=0
t_predicted=0
t_prec=0
t_rec=0
t_f1=0
t_actual=[]
t_pred=[]
t_types=dict()
t_type_scores=dict()
rep_dict = dict()
for f in files:
    if t not in f:
        continue
    #print(f.split("\\")[-1].replace('{0}preds.prop.csv'.format(t), '').replace("_", "\\_"), end='&')
    df=pd.read_csv(f)
    df=df[df['isCandidate']]
    for i in df.index:
        score = df.loc[i]['score']
        if score > threshold:
            r=df.loc[i]['crep'].split("::")[0]
            rep_dict[r]=rep_dict.get(r, 0) + 1

sorted_keys = sorted(rep_dict.keys(), key=lambda x: rep_dict[x], reverse=True)
for s in sorted_keys:
    print("%s:%s" % (s, rep_dict[s]))

print("Keys: %d" % len(sorted_keys))




