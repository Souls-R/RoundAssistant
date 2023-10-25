

let icon_color=0xFF8080
let monitor_id:string='1';
let serviceValueBuffer = new Uint8Array(4);
serviceValueBuffer[0] = 0;
serviceValueBuffer[1] = 0;
serviceValueBuffer[2] = 0;
serviceValueBuffer[3] = 1;
let modifier={
  heart_beat:+30,
  oximetry:-0.02,
  temperature:+0.5,
}

// let icon_color=0xFFCF96
// let monitor_id:string='2';
// let serviceValueBuffer = new Uint8Array(4);
// serviceValueBuffer[0] = 0;
// serviceValueBuffer[1] = 0;
// serviceValueBuffer[2] = 0;
// serviceValueBuffer[3] = 2;
//
// let modifier={
//   heart_beat:+10,
//   oximetry:+0.01,
//   temperature:+0.5,
// }
//


export  {monitor_id,serviceValueBuffer,modifier,icon_color};