import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import bluetoothManager from '@ohos.bluetoothManager';
import Logger from '../util/Logger'
import prompt from '@ohos.prompt';

const TAG = 'EntryAbility'
export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'Ability onCreate')
    Logger.info(TAG, `want param: ${JSON.stringify(want)}`)
    Logger.info(TAG, `launchParam:${JSON.stringify(launchParam)}`)
    AppStorage.SetOrCreate('wantMsg', JSON.stringify(want))
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //共享context
    let context = this.context;
    globalThis.context=context;
    //检查并开启蓝牙
    let state = bluetoothManager.getState();
    if(state==bluetoothManager.BluetoothState.STATE_OFF) {
      bluetoothManager.enableBluetooth();
      prompt.showToast({
        message: '蓝牙未开启，自动启动蓝牙..'
      })
    }
    //加载页面
    windowStage.loadContent('pages/welcome', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
