//
//  CharacteristicSupportedResistanceLevel.swift
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

/// BLE Supported Resistance Level Characteristic
///
/// The Supported Resistance Level Range characteristic is used to send the supported
/// resistance level range as well as the minimum resistance increment supported by the Server
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicSupportedResistanceLevel: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Supported Resistance Level"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2AD6"
    }

    /// Minimum Resistance Level
    private(set) public var minimum: Double

    /// Maximum Resistance Level
    private(set) public var maximum: Double

    /// Minimum Increment
    private(set) public var minimumIncrement: Double

    /// Creates Supported Resistance Level Characteristic
    ///
    /// - Parameters:
    ///   - minimum: Minimum Resistance Level
    ///   - maximum: Maximum Resistance Level
    ///   - minimumIncrement: Minimum Increment
    public init(minimum: Double, maximum: Double, minimumIncrement: Double) {
        self.minimum = minimum
        self.maximum = maximum
        self.minimumIncrement = minimumIncrement

        super.init(name: CharacteristicSupportedResistanceLevel.name,
                   uuidString: CharacteristicSupportedResistanceLevel.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicSupportedResistanceLevel>(with data: Data) -> Result<C, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let minValue = decoder.decodeInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
        let maxValue = decoder.decodeInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
        let incrValue = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)

        let char = CharacteristicSupportedResistanceLevel(minimum: minValue,
                                                          maximum: maxValue,
                                                          minimumIncrement: incrValue)
        return.success(char as! C)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicSupportedResistanceLevel {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        let minValue = Int16(minimum.resolution(.adding, resolution: Resolution.oneTenth))
        let maxValue = Int16(maximum.resolution(.adding, resolution: Resolution.oneTenth))
        let incrValue = UInt16(maximum.resolution(.adding, resolution: Resolution.oneTenth))

        msgData.append(Data(from: minValue.littleEndian))
        msgData.append(Data(from: maxValue.littleEndian))
        msgData.append(Data(from: incrValue.littleEndian))

        return.success(msgData)
    }
}
