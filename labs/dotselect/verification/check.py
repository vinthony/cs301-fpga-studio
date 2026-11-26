import csv, json
from pathlib import Path
rows=list(csv.DictReader(Path('evidence/rtl.csv').open()))
assert len(rows)==64
checks=0
for index,row in enumerate(rows):
    r,d=divmod(index,4)
    values={k:int(v) for k,v in row.items()}
    assert (values['requests'],values['digit'])==(r,d)
    # Independent integer bit selection, rather than a copy of the mux network.
    expected={'low_group':(r//(2**(d%2)))%2,
              'high_group':(r//(2**(2+d%2)))%2,
              'selected':(r//(2**d))%2,'dp':1-(r//(2**d))%2}
    for key,value in expected.items():
        assert values[key]==value,(r,d,key,values[key],value)
        checks+=1
result={'status':'passed','cases':len(rows),'checks':checks}
Path('evidence/rtl-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
