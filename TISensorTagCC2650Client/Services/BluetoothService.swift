//
//  BluetoothService.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/03.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import CoreBluetooth

public protocol BluetoothServiceDelegate {
	func updateValuesInUI(value: Double)
}

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

	// MARK: - Static Properties & Properties
	static let shared = BluetoothService()
	public var centralManager: CBCentralManager!
	public var myPeripheral: CBPeripheral?
	public var delegate: BluetoothServiceDelegate?
	
	private var charIO: CBCharacteristic?
	private var ioVal: UInt8 = 0x0
		
	private override init()	{
		super.init()
		centralManager = CBCentralManager.init(delegate: self, queue: nil)
	}
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == CBManagerState.poweredOn {
			
//			if let pUUIDString = UserDefaults.standard.object(forKey: "PUUID") as? String {
//				if let pUUID = UUID.init(uuidString: pUUIDString) {
//					let peripherals = centralManager.retrievePeripherals(withIdentifiers: [pUUID])
//
//					if let firstPeripheral = peripherals.first {
//						connect(to: firstPeripheral)
//
//						return
//					}
//				}
//			}
			// to fetch connected peripherals
			let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [UUID.initUUID])
			
			if let retrievedPeripheral = peripherals.first {
				connect(to: retrievedPeripheral)
				
				return
			}
			// to scan if necessary
			central.scanForPeripherals(withServices: [UUID.initUUID], options: nil)
			
		}
	}
	
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if peripheral.name?.contains("SensorTag") == true {
			print("****AdvertisementData\n\(advertisementData)")
			
			connect(to: peripheral)
		}
	}
	
	
	private func connect(to toPeripheral: CBPeripheral) {
		
		centralManager.stopScan()
		centralManager.connect(toPeripheral, options: nil)
		
		myPeripheral = toPeripheral
	}
	
	
	// MARK: - didConnect
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.discoverServices(nil)
		peripheral.delegate = self
		
		UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: "PUUID")
		UserDefaults.standard.synchronize()
	}
	
	
	// MARK: - didDisconnectPeripheral
	// when the peripheral loses connection, we want the central to scan again
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		central.scanForPeripherals(withServices: [CBUUID.init(string: "AA80")], options: nil)
	}
	
	
	// MARK: - didFailToConnect
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		central.scanForPeripherals(withServices: [CBUUID.init(string: "AA80")], options: nil)
	}
	
	
	// MARK: - didDiscoverServices
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		if let services = peripheral.services {
			for service in services {
				if service.uuid == UUID.serviceLight {
					print("ServiceLight UUID = \(service.uuid.uuidString)")
					peripheral.discoverCharacteristics(nil, for: service)
				} else if service.uuid == UUID.serviceTemp {
					peripheral.discoverCharacteristics(nil, for: service)
				} else if service.uuid == UUID.serviceKeys {
					peripheral.discoverCharacteristics(nil, for: service)
				} else if service.uuid == UUID.serviceIO {
					peripheral.discoverCharacteristics(nil, for: service)
				}
			}
		}
	}
	
	
	// MARK: - didDiscoverCharacteristics
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		if let chars = service.characteristics {
			for char in chars {
				print("Found characteristic - \(char.uuid.uuidString)")
				if char.uuid == UUID.charLightConfig {
					if char.properties.contains(CBCharacteristicProperties.writeWithoutResponse) {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withoutResponse)
					} else {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withResponse)
					}
				} else if char.uuid == UUID.charTempConfig {
					if char.properties.contains(CBCharacteristicProperties.writeWithoutResponse) {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withoutResponse)
					} else {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withResponse)
					}
				} else if char.uuid == UUID.charIOConfig {
					if char.properties.contains(CBCharacteristicProperties.writeWithoutResponse) {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withoutResponse)
					} else {
						peripheral.writeValue(Data.init(_: [01]), for: char, type: CBCharacteristicWriteType.withResponse)
					}
				} else if char.uuid == UUID.charIOData {
					charIO = char
					ioVal = 0x07
					toggleIO()
				} else if char.uuid == UUID.charLightData {
					checkLight(curChar: char)
				} else if char.uuid == UUID.charTempData {
					checkTemp(tempChar: char)
				} else if char.uuid == UUID.charKeys {
					peripheral.setNotifyValue(true, for: char)
				} else {
					print("Characteristic to configure light isn't found.")
				}
			}
		}
	}
	
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		print("Wrote value")
	}
	
	
	// MARK: - To convert raw data into swift-compatible data
	func luxConvert(value: Data) -> Double {
		let rawData = dataToUnsignedBytes16(value: value)
		
		var e: UInt16 = 0
		var m: UInt16 = 0
		
		m = rawData[0] & 0x0FFF
		e = (rawData[0] & 0xF000) >> 12;
		
		e = (e == 0) ? 1 : 2 << (e - 1);
		
		return Double(m)*(0.01*Double(e))
	}
	
	
	func tempConvert(value: Data) -> Double {
		let rawData = dataToUnsignedBytes16(value: value)
		
		var e: UInt16 = 0
		var m: UInt16 = 0
		
		m = rawData[0] & 0x0FFF
		e = (rawData[0] & 0xF000) >> 12;
		
		e = (e == 0) ? 1 : 2 << (e - 1);
		
		return Double(m)*(0.01*Double(e))
	}
	
	
	func dataToUnsignedBytes16(value: Data) -> [UInt16] {
		
		let count = value.count
		var array = [UInt16](repeating: 0, count: count)
		
		(value as NSData).getBytes(&array, length: count * MemoryLayout<UInt16>.size)
		
		return array
	}
	
	
	// MARK: - To check the light
	func checkLight(curChar: CBCharacteristic) {
		Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
			self.myPeripheral?.readValue(for: curChar)
		}
	}
	
	
	func checkTemp(tempChar: CBCharacteristic) {
		Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
			self.myPeripheral?.readValue(for: tempChar)
		}
	}
	
	
	// MARK: - To toggle IO
	func toggleIO() {
		ioVal += 0x01
		if ioVal == 0x08 { ioVal = 0x0 }
		
		print("ioVal = \(ioVal)")
		
		let data = Data.init(_: [ioVal])
		
		if charIO?.properties.contains(CBCharacteristicProperties.writeWithoutResponse) == true {
			myPeripheral?.writeValue(data, for: charIO!, type: CBCharacteristicWriteType.withoutResponse)
		} else {
			myPeripheral?.writeValue(data, for: charIO!, type: CBCharacteristicWriteType.withResponse)
		}
	}
	
	
	// MARK: - DidUpdateValue
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let value = characteristic.value {
			if characteristic.uuid == UUID.charLightData {
				let luxValue = luxConvert(value: value)
				delegate?.updateValuesInUI(value: luxValue)
			
			} else if characteristic.uuid == UUID.charTempData {
				let tempValue = tempConvert(value: value)
				print("Temp now is = \(tempValue)")
				
			} else if characteristic.uuid == UUID.charKeys {
				print("keys: \([UInt8](value))")
				
				if value != Data.init(_: [0x0]) {
					toggleIO()
				}
			}
			
		}
	}
}


