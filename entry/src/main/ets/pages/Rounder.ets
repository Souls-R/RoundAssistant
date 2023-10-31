/*
 * Copyright (c) 2020-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import distributedDataObject from '@ohos.data.distributedDataObject'
import ble_scanner from  '../model/blescanner'
import Logger from '../util/Logger'

let debounce_timer = null
let TAG = 'rounder'

@Preview
@Entry
@Component
struct Rounder {
  @State ble_info_show: boolean = false
  @State rounder_info: string = 'test'
  @State ble_info: string = 'test'
  @State isDistributed: boolean = false
  @State cur_target:string = ''
  @State fill_color:number = 0xff0000
  @State locale_str:Object = { device_id:'sync_device_id', heart_beat:'heart_beat', oximetry:'oximetry', temperature:'temperature' };
  private ble_scanner:ble_scanner = new ble_scanner()
  private max_id:string = ''
  private last_max_id:string = ''
  private remoteObject

  async aboutToAppear() {
    let context = getContext(this) as any
    //locale
    this.locale_str['sync_device_id']=context.resourceManager.getStringSync($r('app.string.sync_device_id'))
    this.locale_str['heart_beat']=context.resourceManager.getStringSync($r('app.string.heart_beat'))
    this.locale_str['temperature']=context.resourceManager.getStringSync($r('app.string.temperature'))
    this.locale_str['oximetry']=context.resourceManager.getStringSync($r('app.string.oximetry'))
    // 和设备1协同的设备2加入同一个session
    // let sessionId = '1'
    // 创建对象，该对象包含4个属性类型：string、number、boolean和Object
    this.remoteObject = distributedDataObject.create(context, {
      data: undefined,
    })
    // 收到status上线后remoteObject同步数据，即name变成jack,age是18
    // remoteObject.setSessionId(sessionId)
    // 收到同步的数据
    globalThis.changeCallback = (sessionId, changeData) => {
      console.info("change" + sessionId)
      if (changeData != null && changeData != undefined) {
        changeData.forEach(element => {
          this.rounder_info=this.remoteObject[element]
          this.fill_color=this.rounder_info['icon_color']
          // Logger.debug('color'+this.fill_color)
          // console.info("changed !" + element + " " + JSON.stringify(remoteObject[element]))
        })
      }
    }
    this.remoteObject.on("change", globalThis.changeCallback)
    // 蓝牙扫描
    this.ble_scanner.start_scan()
    // 获得扫描结果
    let scan_result = new Map()
    context.eventHub.on("scanner",(data) => {
      // Logger.debug('scanner report')
      scan_result.set(data['id'],data)
      // 选择最强信号
      this.last_max_id = this.max_id
      let max_dBm = -120
      scan_result.forEach((device) => {
        if(max_dBm < Number(device['rssi'])) {
          max_dBm = Number(device['rssi'])
          this.max_id = device['id']
        }
      })
      if(this.cur_target != this.max_id) {
        // 第一次信号到来
        if(this.cur_target == '') {
          this.changeSession()
          this.cur_target = this.max_id
          this.last_max_id = this.max_id
        }
        if(this.last_max_id != this.max_id) {
          this.target_change_debounce()
        }
      }
      //输出结果
      let tmp_msg = ''
      scan_result.forEach((device) => {
        tmp_msg = tmp_msg + 'device id: '+String(device['id'])+' rssi:' + String(device['rssi']) + 'dBm'/*  id:'+String(device['deviceId'])*/ + '\n\n'
      })
      this.ble_info = 'max dBm id:' + this.max_id + '\n' + tmp_msg
    })
  }

  target_change_debounce(wait=1000) {
     // Logger.debug('deb')
    let self = this
    if(debounce_timer) {//如果存在定时器就清空
      Logger.debug('change cleaned.')
      clearTimeout(debounce_timer)
    }
      debounce_timer = setTimeout(function() {
        self.changeSession()
      }, wait)
  }

  changeSession() {
    if(this.cur_target == '') {
      Logger.debug('truly changed to' + this.max_id)
      this.cur_target = this.max_id
      this.remoteObject.setSessionId(String(this.cur_target))
    }
    if(this.cur_target == this.max_id) {
      return
    }
    this.cur_target = this.max_id
    Logger.debug('truly changed to' + this.max_id)
    this.remoteObject.setSessionId()
    this.remoteObject.setSessionId(String(this.cur_target))
  }


  build() {
    Column() {

      Row() {
        Text($r('app.string.page_title_rounder'))
          .width('100%')
          .height('8%')
          .constraintSize({ minHeight: 50 })
          .fontSize(25)
          .margin({ left: 20,top: 7 })

        // Image($r('app.media.ic_more'))
        //   .width(55).height(51)
      }
      Divider()
      // 设备
      Row(){
        Image($r('app.media.ic_monitor'))
          .width(55).height(51)
          .scale({x : 1.5,y : 1.5,})
          .margin({ left: 50, top: 7 })

        Text( `${this.locale_str['sync_device_id']} :  ${String(this.cur_target)} `)
          .fontSize(25)
          .margin({ left: 42 })
      }.height('16%').width('90%')
      .margin({top:32})
      .borderRadius(12)
      .shadow({radius:16,color:0x20000000})
      .onClick(() => {
        this.ble_info_show = !this.ble_info_show
      })
      // 心率
      Row(){
        Image($r('app.media.ic_heartbeat'))
          .width(64).height(64)
          .scale({x : 1.4,y : 1.4,})
          .margin({ left: 50, top: 7 })
          .fillColor(this.fill_color)

        Text(`${this.locale_str['heart_beat']} :  ${this.rounder_info['heart_beat']} bpm`)
          .fontSize(25)
          .margin({ left: 32 })
      }.height('16%').width('90%')
      .margin({top:16})
      .borderRadius(12)
      .shadow({radius:16,color:0x20000000})
      // 血氧
      Row(){
        Image($r('app.media.ic_oximetry'))
          .width(64).height(64)
          .scale({x : 1.6,y : 1.6,})
          .margin({ left: 50, top: 7 })
          .fillColor(this.fill_color)

        Text(`${this.locale_str['oximetry']} :  ${this.rounder_info['oximetry']*100} %`)
          .fontSize(25)
          .margin({ left: 32 })
      }.height('16%').width('90%')
      .margin({top:16})
      .borderRadius(12)
      .shadow({radius:16,color:0x20000000})
      // 温度
      Row(){
        Image($r('app.media.ic_temperature'))
          .width(64).height(64)
          .scale({x : 1.6,y : 1.6,})
          .margin({ left: 50, top: 7 })
          .fillColor(this.fill_color)

        Text(`${this.locale_str['temperature']} :  ${this.rounder_info['temperature']} °C`)
          .fontSize(25).margin({ left: 32 })
      }.height('16%').width('90%')
      .margin({top:16})
      .borderRadius(12)
      .shadow({radius:16,color:0x20000000})

      if(this.ble_info_show){
      Text(`BlueTooth Info:`)
        .fontSize('25vp')
      Text(`${this.ble_info}`)
        .fontSize('25vp')
      }

    }
  }

}