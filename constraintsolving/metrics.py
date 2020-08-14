import pandas as pd
from pygments.lexer import default
from sklearn.metrics import precision_score, recall_score, f1_score
from glob import glob
import warnings
warnings.filterwarnings("ignore")

files=glob('results/*/NoSqlInjection-0.45/*epf.prop.csv', recursive=True)
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
for f in files:
    if t not in f:
        continue
    print(f.split("\\")[-1].replace('{0}preds.prop.csv'.format(t), '').replace("_", "\\_"), end='&')
    df=pd.read_csv(f)
    df=df[df['isCandidate']]
    indices=df.index
    actual=[1 if df.loc[k]['isKnown'] is True else 0 for k in indices]
    predicted=[1 if df.loc[k]['score'] > threshold and df.loc[k]['isEffective'] else 0 for k in indices]
    prec=precision_score(actual, predicted)
    recall=recall_score(actual, predicted)
    f1=f1_score(actual, predicted)
    n_known=len(df[df['isKnown']])
    n_predicted=len(df[(df['score'] > threshold) & (df['isEffective'])])
    #print(df.index)
    for entry in indices:
        if df.loc[entry]['score'] > threshold and df.loc[entry]['isEffective']:
            t_types[df.loc[entry]["type"]] = t_types.get(df.loc[entry]["type"], 0) + 1
            tup = t_type_scores.get(df.loc[entry]["type"], [0, 0])
            if df.loc[entry]['isKnown']:
                tup[0]=tup[0]+1
            else:
                tup[1]=tup[1]+1
            t_type_scores[df.loc[entry]["type"]] = tup


    print(n_known, end='&')
    print(n_predicted, end='&')
    print("{0:.2f}".format(prec), end='&')
    print("{0:.2f}".format(recall), end='&')
    print("{0:.2f}".format(f1), end='\\\\\n')

    if n_known > 0:
        total+=1
        t_prec+=prec
        t_rec+=recall
        t_f1+=f1
        t_known+=n_known
        t_predicted+=n_predicted
        t_actual=t_actual+actual
        t_pred=t_pred+predicted

print("\\midrule\nTotal/Avg&{0}&{1}&{2:.2f}&{3:.2f}&{4:.2f}\\\\\\bottomrule".format(t_known, t_predicted,
                                                         precision_score(t_actual, t_pred),
                                                         recall_score(t_actual, t_pred),
                                                         f1_score(t_actual, t_pred)
                                                         ))
print(t_types)
print(t_type_scores)