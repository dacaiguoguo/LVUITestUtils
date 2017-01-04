//
//  LVUITestServer.swift
//
//  Copyright (c) 2015 Andrey Fidrya
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

import UIKit
import Swifter

open class LVUITestServer:NSObject  {
    typealias T = LVUITestServer
    open static let sharedInstance = LVUITestServer()
    
    open func listen(_ port: in_port_t = 5000) {
        if !PrivateUtils.debug() {
            print("WARNING: LVUITestServer disabled because DEBUG is not defined")
            return
        }
        let server = demoServer("")
        
        server["/screenshot.png"] = { request in
            var dataOrNil: Data?
            DispatchQueue.main.sync {
                if let screenshot = LVUITestServer.takeScreenshot() {
                    if let screenshotData = UIImagePNGRepresentation(screenshot) {
                        dataOrNil = screenshotData
                    }
                }
            }
            guard let data = dataOrNil else {
                print("Unable to create screenshot")
                return .internalServerError
            }
            return HttpResponse.raw(200, "OK", nil, {
                try $0.write(data)
            })
        }
        
        
        server["/screenResolution"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let resolution = LVUITestServer.screenResolution()
                if let resolutionData = resolution.data(using: String.Encoding.utf8) {
                    data = resolutionData
                }
            }
            return .raw(200, "OK", nil, {
                try $0.write(data)
            })
        }
        
        server["/deviceType"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let deviceType = LVUITestServer.deviceType()
                if let deviceTypeData = deviceType.data(using: String.Encoding.utf8) {
                    data = deviceTypeData
                }
            }
            return .raw(200, "OK", nil, {
                try $0.write(data)
            })
        }
        
        server["/orientation"] = { request in
            var data = Data()
            DispatchQueue.main.sync {
                let orientationString = String(UIApplication.shared.statusBarOrientation.rawValue)
                if let orientationData = orientationString.data(using: String.Encoding.utf8) {
                    data = orientationData
                }
            }
            return .raw(200, "OK", nil, {
                try $0.write(data)
            })
        }
        
        server["/setOrientation/:orientation"] = { request in
            let (_, value) = request.params.first!
            if let orientationString = Int32(value) {
                let orientation = Int(orientationString)
                DispatchQueue.main.async {
                    PrivateUtils.forceOrientation(Int32(orientation ))
                }
            }
            return .raw(200, "OK", nil,{ try $0.write([UInt8]()) })
        }
        
        print("Starting UI Test server on port \(port)")
        do {
            try server.start(port)
        } catch {
            print("Failed to start the server")
        }
    }
    

    
    fileprivate class func takeScreenshot() -> UIImage? {
        return PrivateUtils.takeScreenshot()
    }
    
    fileprivate class func screenResolution() -> String {
        let screen = UIScreen.main
        let bounds = screen.bounds
        let scale = screen.scale
        let width = Int(bounds.size.width * scale)
        let height = Int(bounds.size.height * scale)
        return "\(width)x\(height)"
    }
    
    fileprivate class func deviceType() -> String {
        return UIDevice.current.userInterfaceIdiom == .pad ? "pad" : "phone"
    }
    

}
