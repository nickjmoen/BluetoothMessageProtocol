//
//  CharacteristicDewPoint.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/19/17.
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

/// BLE Dew Point Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicDewPoint: Characteristic {

    public static var name: String {
        return "Dew Point"
    }

    public static var uuidString: String {
        return "2A7B"
    }

    /// Dew Point
    fileprivate(set) public var dewPoint: Measurement<UnitTemperature>

    public init(dewPoint: Measurement<UnitTemperature>) {

        self.dewPoint = dewPoint

        super.init(name: CharacteristicDewPoint.name, uuidString: CharacteristicDewPoint.uuidString)
    }

    open override class func decode(data: Data) throws -> CharacteristicDewPoint {

        var decoder = DataDecoder(data)

        let dewpoint: Measurement = Measurement(value: Double(decoder.decodeInt8()), unit: UnitTemperature.celsius)

        return CharacteristicDewPoint(dewPoint: dewpoint)
    }

    open override func encode() throws -> Data {
        var msgData = Data()

        //Make sure we put this back to Celsius before we create Data
        let temperature = dewPoint.converted(to: UnitTemperature.celsius).value

        msgData.append(Data(from: Int8(temperature)))

        return msgData
    }
}
