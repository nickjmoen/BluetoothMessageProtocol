//
//  ServiceContinuousGlucoseMonitoring.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 9/2/17.
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


/// BLE Continuous Glucose Monitoring Service
///
/// This service exposes glucose and other data from a personal Continuous Glucose Monitoring (CGM) sensor for use in consumer healthcare applications.
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class ServiceContinuousGlucoseMonitoring: Service {

    public static var name: String {
        return "Continuous Glucose Monitoring"
    }

    public static var uuidString: String {
        return "181F"
    }

    public static var uniformIdentifier: String {
        return "org.bluetooth.service.continuous_glucose_monitoring"
    }

    public init() {
        super.init(name: ServiceContinuousGlucoseMonitoring.name,
                   uuidString: ServiceContinuousGlucoseMonitoring.uuidString,
                   uniformIdentifier: ServiceContinuousGlucoseMonitoring.uniformIdentifier
        )
    }
}