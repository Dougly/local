//
//  NSURLRequestExtension.swift
//  Local
//
//  Created by Douglas Galante on 7/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation

extension NSURLRequest {
    class func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
}
