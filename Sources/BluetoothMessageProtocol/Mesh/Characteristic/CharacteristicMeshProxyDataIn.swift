//
//  CharacteristicMeshProxyDataIn.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 7/4/18.
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

/// BLE Mesh Proxy Data In Characteristic
///
/// The Mesh Proxy Data In characteristic is used by the client to send Proxy PDUs to the server
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicMeshProxyDataIn: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Mesh Proxy Data In"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2ADD"
    }

    /// Proxy Protocol Data Unit (PDU) Message
    ///
    /// The Mesh Proxy Data In characteristic shall support Proxy PDU messages
    /// containing Network PDUs, mesh beacons, and proxy configuration messages
    /// and shall not support other Proxy PDU type messages
    private(set) public var pduMessage: ProxyDataUnit

    /// Creates Characteristic
    ///
    /// - Parameter pduMessage: Proxy PDU Message
    public init(pduMessage: ProxyDataUnit) {
        self.pduMessage = pduMessage

        super.init(name: CharacteristicMeshProxyDataIn.name,
                   uuidString: CharacteristicMeshProxyDataIn.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decode<C: CharacteristicMeshProxyDataIn>(with data: Data) -> Result<C, BluetoothDecodeError> {
        return.failure(BluetoothDecodeError.notSupported)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicMeshProxyDataIn {
        return try decode(with: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {

        guard pduMessage is ProxyDataUnitProvisioning == false else {
            return.failure(BluetoothEncodeError.general("P roxy Data Unit of type Provisioning is not supported."))
        }

        switch pduMessage.encode() {
        case .success(let pduMessage):
            var msgData = Data()
            
            msgData.append(pduMessage)
            
            return.success(msgData)

        case .failure(let error):
            return.failure(error)
        }
    }
}
