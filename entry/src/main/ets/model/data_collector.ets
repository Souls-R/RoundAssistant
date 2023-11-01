
import { modifier, icon_color } from  '../util/constant'


let rand_gen = () => {
    // 60~70
    let new_heart_beat = (60 + Math.random() * 10 + modifier.heart_beat).toFixed(0)
    // 0.95~0.96
    let new_oximetry = (0.95 + Math.random() * 0.01 + modifier.oximetry).toFixed(2)
    // 36.1~36.3
    let new_temperature = (36.1 + Math.random() * 0.2 + modifier.temperature).toFixed(1)
    let new_data = {
      heart_beat: new_heart_beat,
      oximetry: new_oximetry,
      temperature: new_temperature,
      icon_color: icon_color
    }
    return new_data
  }

//other data collector implement

export {rand_gen}