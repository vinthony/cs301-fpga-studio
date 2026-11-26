import assert from 'node:assert/strict';
import {gateTrace} from '../gbu-game/gate-replay.js';
const sample=values=>values.map(led=>({led}));
let rows=gateTrace(sample(['0000','0001','0000','0000']));
assert.deepEqual(rows.map(r=>[r.a,r.b,r.actual,r.expected]),[[0,0,0,0],[1,0,1,1],[0,1,0,0],[1,1,0,0]]);
assert.equal(gateTrace(sample(['0','x','0','0']))[1].actual,null,'unknown RTL values must not be treated as zero');
assert.throws(()=>gateTrace([]),/不完整/,'a partial response cannot pass');
assert.equal(gateTrace(sample(['0','0','0','1']))[3].actual,1,'failure samples preserve actual output');
console.log('PASS: RTL gate replay sample order, failed and unknown outputs, incomplete response');
