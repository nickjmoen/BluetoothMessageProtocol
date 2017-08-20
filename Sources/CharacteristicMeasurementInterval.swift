//
//  CharacteristicMeasurementInterval.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/20/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import DataDecoder
import FitnessUnits

/// BLE Measurement Interval Characteristic
///
/// The Measurement Interval characteristic defines the time between measurements
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicMeasurementInterval: Characteristic {

    public static var name: String {
        return "Measurement Interval"
    }

    public static var uuidString: String {
        return "2A21"
    }

    /// Measurement Interval
    ///
    /// - note: values from 1 second to 65535 seconds
    private(set) public var interval: Measurement<UnitDuration>


    public init(interval: Measurement<UnitDuration>) {

        self.interval = interval

        super.init(name: CharacteristicMeasurementInterval.name, uuidString: CharacteristicMeasurementInterval.uuidString)
    }

    open override class func decode(data: Data) throws -> CharacteristicMeasurementInterval {

        var decoder = DataDecoder(data)

        let value = Double(decoder.decodeUInt16())

        let interval = Measurement(value: value, unit: UnitDuration.seconds)

        return CharacteristicMeasurementInterval(interval: interval)
    }

    open override func encode() throws -> Data {
        //Make sure we put this back to Seconds before we create Data
        let value = UInt16(interval.converted(to: UnitDuration.seconds).value)

        guard kBluetoothMeasurementIntervalBounds.contains(Int(value)) else {
            throw BluetoothMessageProtocolError.init(.decodeError(msg: "Measurement Interval must be between \(kBluetoothMeasurementIntervalBounds.lowerBound) and \(kBluetoothMeasurementIntervalBounds.upperBound) seconds"))
        }

        var msgData = Data()

        msgData.append(Data(from: value.littleEndian))

        return msgData
    }
}
