// Original, optional procedural music; no external audio assets or autoplay.
export function createAudio(){let ctx=null,timer=null,on=false,step=0,master=null;
 const notes=[659,784,880,784,659,587,523,587,659,784,988,880,784,659,587,523];
 function tone(freq,duration,start,gain=.035,type='sine'){let o=ctx.createOscillator(),g=ctx.createGain();o.type=type;o.frequency.setValueAtTime(freq,start);g.gain.setValueAtTime(.0001,start);g.gain.exponentialRampToValueAtTime(gain,start+.035);g.gain.exponentialRampToValueAtTime(.0001,start+duration);o.connect(g);g.connect(master);o.start(start);o.stop(start+duration+.03)}
 function tick(){if(!on)return;let t=ctx.currentTime+.03;tone(notes[step%notes.length],.48,t,.04,'triangle');if(step%4===0){let chords=[[261.63,329.63,392],[220,261.63,329.63],[174.61,220,261.63],[196,246.94,293.66]][Math.floor(step/4)%4];chords.forEach(f=>tone(f,1.35,t,.009,'sine'))}step++;timer=setTimeout(tick,430)}
 return {async toggle(){if(on){on=false;clearTimeout(timer);if(ctx)await ctx.suspend();return false}ctx??=new AudioContext();if(!master){master=ctx.createGain();master.gain.value=.42;master.connect(ctx.destination)}await ctx.resume();on=true;tick();return true},get active(){return on}};
}
