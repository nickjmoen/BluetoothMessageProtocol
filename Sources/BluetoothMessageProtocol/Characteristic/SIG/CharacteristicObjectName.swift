//
//  CharacteristicObjectName.swift
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

/// BLE Object Name Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicObjectName: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Object Name"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2ABE"
    }

    /// Object Name
    private(set) public var objectName: String

    /// Creates Object Name Characteristic
    ///
    /// - Parameter objectName: Object Name
    public init(objectName: String) {
        self.objectName = objectName

        super.init(name: CharacteristicObjectName.name,
                   uuidString: CharacteristicObjectName.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicObjectName>(with data: Data) -> Result<C, BluetoothDecodeError> {

        if let objectName = data.safeStringValue {
            return.success(CharacteristicObjectName(objectName: objectName) as! C)
        }
        
        return.failure(.invalidStringValue)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicObjectName {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        guard kObjectNameStringBounds.contains(objectName.count) else {
            return.failure(BluetoothEncodeError.boundsError(title: "Object Name must be between",
                                                            msg: "characters in size",
                                                            range: kObjectNameStringBounds))
        }

        if let stringData = objectName.data(using: .utf8) {
            msgData.append(stringData)
        }

        return.success(msgData)
    }
}
