//
//  CharacteristicHeartRateControlPoint.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/5/17.
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

/// BLE Heart Rate Control Point Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicHeartRateControlPoint: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Heart Rate Control Point"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2A39"
    }

    /// Control Point Commands
    public enum Command: UInt8 {
        /// Reset Energy Expended
        case resetEnergyExpended    = 1
    }

    /// The Control Command for the Control Point
    public var controlMessage: Command

    /// Creates Heart Rate Control Point Characteristic
    ///
    /// - Parameter controlMessage: Control Command
    public init(controlMessage: Command) {
        self.controlMessage = controlMessage

        super.init(name: CharacteristicHeartRateControlPoint.name,
                   uuidString: CharacteristicHeartRateControlPoint.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicHeartRateControlPoint>(with data: Data) -> Result<C, BluetoothDecodeError> {
        //Not Yet Supported
        return.failure(BluetoothDecodeError.notSupported)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicHeartRateControlPoint {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        msgData.append(controlMessage.rawValue)

        return.success(msgData)
    }
}
