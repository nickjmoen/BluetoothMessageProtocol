//
//  CharacteristicTacxAntFecSend.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 3/31/18.
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

/// BLE Tacx ANT-FEC Send Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicTacxAntFecSend: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Tacx ANT-FEC Send"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "6E40FEC3-B5A3-F393-E0A9-E50E24DCCA9E"
    }

    /// ANT-FEC Data
    private(set) public var antData: Data

    /// Creates Tacx ANT-FEC Send Characteristic
    ///
    /// - Parameter antData: ANT Message
    public init(antData: Data) {

        self.antData = antData

        super.init(name: CharacteristicTacxAntFecSend.name,
                   uuidString: CharacteristicTacxAntFecSend.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicTacxAntFecSend>(with data: Data) -> Result<C, BluetoothDecodeError> {
        /// We don't need to ever decode it
        return.failure(BluetoothDecodeError.notSupported) 
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicTacxAntFecSend {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        /// Check to make sure the Sync byte is correct
        guard antData[0] == 0xA4 else {
            return.failure(BluetoothEncodeError.general("ANT Sync mismatch."))
        }

        return.success(antData)
    }
}
