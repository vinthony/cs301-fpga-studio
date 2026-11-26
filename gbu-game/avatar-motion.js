// The artwork has four rows: front, left, right, back. Resolve movement in
// camera-relative screen coordinates so the visible pose follows orbiting.
export function avatarPose(dx,dz,rightX,rightZ,backX,backZ,walk){
 const horizontal=(dx*rightX+dz*rightZ)/(Math.hypot(rightX,rightZ)||1), toward=(dx*backX+dz*backZ)/(Math.hypot(backX,backZ)||1);
 const facing=Math.abs(horizontal)>Math.abs(toward)?(horizontal<0?1:2):(toward<0?3:0);
 return {facing,frame:Math.floor(walk/2)%4};
}
// Convert the controls from screen right/down to the camera's ground plane.
export function screenToWorld(horizontal,toward,rightX,rightZ,backX,backZ){
 const r=Math.hypot(rightX,rightZ)||1,b=Math.hypot(backX,backZ)||1;
 return {x:horizontal*rightX/r+toward*backX/b,z:horizontal*rightZ/r+toward*backZ/b};
}
