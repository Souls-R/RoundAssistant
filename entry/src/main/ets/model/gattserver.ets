import bluetoothManager from '@ohos.bluetoothManager';
import {serviceValueBuffer} from '../util/constant'



let TAG = 'myble';
let manufactureValueBuffer = new Uint8Array(4);
manufactureValueBuffer[0] = 4;
manufactureValueBuffer[1] = 4;
manufactureValueBuffer[2] = 4;
manufactureValueBuffer[3] = 4;
// let serviceValueBuffer = new Uint8Array(4);
// serviceValueBuffer[0] = 0;
// serviceValueBuffer[1] = 0;
// serviceValueBuffer[2] = 0;
// serviceValueBuffer[3] = 1;
let setting = {
  interval: 150,
  txPower: 0,
  connectable: true,
};
let manufactureDataUnit = {
  manufactureId: 4444,
  manufactureValue: manufactureValueBuffer.buffer
};
let serviceDataUnit = {
  serviceUuid: "00001889-0000-1000-8000-00805f9b34fb",
  serviceValue: serviceValueBuffer.buffer
};
let advData = {
  serviceUuids: ["00001889-0000-1000-8000-00805f9b34fb"],
  manufactureData: [manufactureDataUnit],
  serviceData: [serviceDataUnit],
};

///

export default  class gatt_server{
  gattServer: bluetoothManager.GattServer;
  server_status:Boolean = false;

  constructor() {
    this.gattServer=bluetoothManager.BLE.createGattServer();
    console.info(TAG, 'gatt server create');
  }

  start_gatt_server() {
    if(this.server_status){
      console.info(TAG, 'gatt server start already!');
      return;
    }
    console.info(TAG, 'gatt server start...');
    try {
      this.gattServer.startAdvertising(setting, advData);
      this.server_status=true;
    } catch (err) {
      console.error(TAG,"errCode:" + err.code + ",errMessage:" + err.message);
    }
  }

   stop_gatt_server() {
     if(this.server_status==false){
       console.info(TAG, 'gatt server stop already!');
       return;
     }
    console.info(TAG, 'gatt server stop!!!');
    try {
      this.gattServer.stopAdvertising();
      this.server_status=false;
    } catch (err) {
      console.error(TAG, "errCode:" + err.code + ",errMessage:" + err.message);
    }
  }

}