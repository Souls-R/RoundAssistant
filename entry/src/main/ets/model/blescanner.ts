import bluetoothManager from '@ohos.bluetoothManager';
let TAG='myble';

export function advData_parser(data:ArrayBuffer){
  //暂时的字段定义：manufacture id=0x04040404表示我们的设备
  //             service uuid=0x1889也表示我们的设备
  //             1889service的data表示设备编号,sample里是0,0,0,1   下标位置为12，13，14，15(方便起见暂时统一按array buffer顺序来，不考虑网络序)
  let sample=[7,255,  215,17,  4,4,4,4,    7,22,137,24,    0,0,0,1,    3,3,137,24,2,1,2,4,9,114,97,49,2,10,12,4,9,114,97,49]
  try{
    let n0=Number(data[12]);
    let n1=Number(data[13]);
    let n2=Number(data[14]);
    let n3=Number(data[15]);
    let id=n3+n2*256+n1*256*256+n0*256*256*256;
    return id;
  }
  catch (err) {
    console.error(TAG, "errCode:" + err.code + ",errMessage:" + err.message);
  }
}


export default class ble_scanner{

  onReceiveEvent(ScanResult) {
    let deviceId = ScanResult[0]['deviceId'];
    let rssi = ScanResult[0]['rssi'];
    let data:ArrayBuffer = ScanResult[0]['data'];
    let id = advData_parser(data);
    //console.info('RoundAssistant','BLE scan device find result:', deviceId,'|',rssi,'|',id);
    let scan_result={'deviceId':deviceId,'rssi':rssi,'id':id};
    globalThis.context.eventHub.emit('scanner',scan_result)

  }

  start_scan(){
    console.log(TAG,"start scan....");
    try {
      bluetoothManager.BLE.on("BLEDeviceFind", this.onReceiveEvent);
      bluetoothManager.BLE.startBLEScan(
        [{
          serviceUuid:"00001889-0000-1000-8000-00805f9b34fb",
          manufactureId:4444,
        }],
        {
          interval: 0,
          dutyMode: bluetoothManager.ScanDuty.SCAN_MODE_LOW_LATENCY,
          matchMode: bluetoothManager.MatchMode.MATCH_MODE_AGGRESSIVE,
        }
      );
    } catch (err) {
      console.error(TAG, "errCode:" + err.code + ",errMessage:" + err.message);
    }
  }

}