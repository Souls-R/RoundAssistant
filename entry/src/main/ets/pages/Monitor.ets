import distributedDataObject from '@ohos.data.distributedDataObject';
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { monitor_id,modifier,icon_color } from  '../util/constant'
import gatt_server from '../model/gattserver'
let self
let localObject:distributedDataObject.DataObject



@Entry
@Component
struct Monitor {
  @State message: string = 'Hello World'
  @State monitor_info: Object = { heart_beat:70,oximetry:0.98,temperature:36.7 } ;
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  private my_gatt_server:gatt_server = new gatt_server();


  //
  // getRandomColor() {
  //   const letters = '0123456789ABCDEF';
  //   let color = '0x';
  //   for (let i = 0; i < 6; i++) {
  //     color += letters[Math.floor(Math.random() * 16)];
  //   }
  //   return color;
  // }


  rand_gen(){
    //60~70
    let new_heart_beat=(60+Math.random()*10+modifier.heart_beat).toFixed(0);
    //0.95~0.96
    let new_oximetry=(0.95+Math.random()*0.01+modifier.oximetry).toFixed(2);
    //36.1~36.3
    let new_temperature = (36.1 + Math.random()*0.2+modifier.temperature).toFixed(1);
    let new_data={heart_beat: new_heart_beat,
                  oximetry: new_oximetry,
                  temperature: new_temperature,
                  icon_color:icon_color
                  }
    self.monitor_info=new_data
    localObject['data']=new_data
  }

  async aboutToAppear(){
    self=this
    let context = getContext(this) as any
    localObject = distributedDataObject.create(context, {
      data:
        {
          heart_beat: 0,
          oximetry: 0,
          temperature: 0
        }
    });
    // 设备1加入sessionId
    let sessionId = monitor_id;
    localObject.setSessionId(sessionId);
    //定时生成模拟数据
    setInterval(this.rand_gen, 600);
    //开启广播
    this.my_gatt_server.start_gatt_server();

  }



  aboutToDisappear(){
    //关闭广播
    this.my_gatt_server.stop_gatt_server();
  }


  build() {
    Row() {
      Column() {

        Row() {
          Text('病床端-病床数据采集')
            .width('100%')
            .height('8%')
            .constraintSize({ minHeight: 50 })
            .fontSize(25)
            .margin({ left: 20,top: 7 })
          //
          // Image($r('app.media.ic_more'))
          //   .width(55).height(51)
        }
         Divider()

        //设备
        Row(){
          Image($r('app.media.ic_monitor'))
            .width(55).height(51)
            .scale({x : 1.5,y : 1.5,})
            .margin({ left: 50, top: 7 })

          Text(`设备ID:  ${monitor_id} `)
            .fontSize(25).margin({ left: 42 })
        }.height('16%').width('90%').margin({top:32})
        .borderRadius(12).shadow({radius:16,color:0x20000000})
        //心率
        Row(){
          Image($r('app.media.ic_heartbeat'))
            .width(64).height(64)
            .scale({x : 1.4,y : 1.4,})
            .margin({ left: 50, top: 7 })
            .fillColor(icon_color)

          Text(`心率:  ${this.monitor_info['heart_beat']} bpm`)
            .fontSize(25).margin({ left: 32 })
        }.height('16%').width('90%').margin({top:16})
        .borderRadius(12).shadow({radius:16,color:0x20000000})
        //血氧
        Row(){
          Image($r('app.media.ic_oximetry'))
            .width(64).height(64)
            .scale({x : 1.6,y : 1.6,})
            .margin({ left: 50, top: 7 })
            .fillColor(icon_color)

          Text(`血氧:  ${this.monitor_info['oximetry']*100} %`)
            .fontSize(25).margin({ left: 32 })
        }.height('16%').width('90%').margin({top:16})
        .borderRadius(12).shadow({radius:16,color:0x20000000})
        //温度
        Row(){
          Image($r('app.media.ic_temperature'))
            .width(64).height(64)
            .scale({x : 1.6,y : 1.6,})
            .margin({ left: 50, top: 7 })
            .fillColor(icon_color)

          Text(`温度:  ${this.monitor_info['temperature']} °C`)
            .fontSize(25).margin({ left: 32 })
        }.height('16%').width('90%').margin({top:16})
        .borderRadius(12).shadow({radius:16,color:0x20000000})



        if(false){
        Text(`${this.monitor_info}`)
          .margin({top:20})
          .fontSize(8)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.rand_gen()
          })
        }

      }
      .width('100%')
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }
}