//
//  CharacteristicSupportedInclinationRange.swift
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

/// BLE Supported Inclination Range Characteristic
///
/// The Supported Inclination Range characteristic is used to send the supported
/// inclination range as well as the minimum inclination increment supported by the Server
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicSupportedInclinationRange: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Supported Inclination Range"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2AD5"
    }

    /// Minimum Inclination
    private(set) public var minimum: FitnessMachineInclinationType

    /// Maximum Inclination
    private(set) public var maximum: FitnessMachineInclinationType

    /// Minimum Increment
    private(set) public var minimumIncrement: Measurement<UnitPercent>

    /// Creates Supported Inclination Range Characteristic
    ///
    /// - Parameters:
    ///   - minimum: Minimum Inclination
    ///   - maximum: Maximum Inclination
    ///   - minimumIncrement: Minimum Increment
    public init(minimum: FitnessMachineInclinationType,
                maximum: FitnessMachineInclinationType,
                minimumIncrement: Measurement<UnitPercent>) {

        self.minimum = minimum
        self.maximum = maximum
        self.minimumIncrement = minimumIncrement

        super.init(name: CharacteristicSupportedInclinationRange.name,
                   uuidString: CharacteristicSupportedInclinationRange.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicSupportedInclinationRange>(with data: Data) -> Result<C, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let minimum = FitnessMachineInclinationType.create(decoder.decodeInt16(data))
        let maximum = FitnessMachineInclinationType.create(decoder.decodeInt16(data))
        
        let incrValue = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
        let minimumIncrement = Measurement(value: incrValue, unit: UnitPercent.percent)

        let char = CharacteristicSupportedInclinationRange(minimum: minimum,
                                                           maximum: maximum,
                                                           minimumIncrement: minimumIncrement)
        return.success(char as! C)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicSupportedInclinationRange {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        let minValue = minimum.encode()
        let maxValue = maximum.encode()
        let incrValue = UInt16(minimumIncrement.value.resolution(.adding, resolution: Resolution.oneTenth))

        msgData.append(minValue)
        msgData.append(maxValue)
        msgData.append(Data(from: incrValue.littleEndian))

        return.success(msgData)
    }
}
