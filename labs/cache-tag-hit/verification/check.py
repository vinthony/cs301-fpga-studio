import csv,json
from pathlib import Path
rows=list(csv.DictReader(Path('evidence/rtl.csv').open()))
assert len(rows)==2048
checks=0
for index,row in enumerate(rows):
    a,b,v=index//64,(index//2)%32,index%2
    got={key:int(value) for key,value in row.items()}
    assert (got['request'],got['saved'],got['valid'])==(a,b,v)
    # Compare integer residues independently of the gate network.
    expected={'different':a^b,'same':31^(a^b),
              'low_two':int(a%4==b%4),'middle_two':int(a//4%4==b//4%4),
              'low_four':int(a%16==b%16),'equal':int(a==b),
              'hit':int(a==b and v==1)}
    for key,value in expected.items():
        assert got[key]==value,(a,b,v,key,got[key],value)
        checks+=1
result={'status':'passed','cases':len(rows),'checks':checks}
Path('evidence/rtl-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
