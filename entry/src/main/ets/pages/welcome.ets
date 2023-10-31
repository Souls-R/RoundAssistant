import common from '@ohos.app.ability.common'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import Logger from '../util/Logger'
import router from '@ohos.router'

let TAG = 'welcome'

@Entry
@Component
struct Welcome {

  aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(context,['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`)
    }
  }

  build() {
    Row() {
      Column() {

        Column() {
          Image($r('app.media.ic_more'))
            .width(32).height(32)
            .margin({right:24,top:0})
            .onClick(()=>{
              router.pushUrl ({
                url: 'pages/DeviceManager',
              });
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.End)


        Row() {
          Image($r('app.media.ic_health'))
            .width(55).height(70)
            .margin({right:32})

          Text($r('app.string.welcome_title'))
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }.margin({top:100})

        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Column() {
            Text($r('app.string.welcome_bedside'))
              .fontSize(45)
              .fontColor(0xffffff)
              .margin({ left: 12 ,top:16})
              .letterSpacing(6)
            Text($r('app.string.welcome_bedside_des'))
              .fontSize(16)
              .fontColor(0xbfffffff)
              .margin({ left: 16,top:16,right:16 })
              .letterSpacing(2)
          }.alignItems(HorizontalAlign.Start)
          .width('90%').height(160)
        }.backgroundColor(0x317aff)
        .margin({top:120})
        .borderRadius(8)
        .onClick(()=>{
          router.replaceUrl ({
            url: 'pages/Monitor',
          });
        })

        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Column() {
            Text($r('app.string.welcome_doctorside'))
              .fontSize(45)
              .fontColor(0xffffff)
              .margin({ left: 12 ,top:16})
              .letterSpacing(6)
            Text($r('app.string.welcome_doctorside_des'))
              .fontSize(16)
              .fontColor(0xbfffffff)
              .margin({ left: 16,top:16,right:16 })
              .letterSpacing(2)
          }.alignItems(HorizontalAlign.Start)
          .width('90%').height(160)
        }.backgroundColor(0x317aff)
        .margin({top:20})
        .borderRadius(8)
        .onClick(()=>{
          router.replaceUrl ({
            url: 'pages/Rounder',
          });
        })
      }
      .width('100%')
    }
    .height('100%')
  }

}