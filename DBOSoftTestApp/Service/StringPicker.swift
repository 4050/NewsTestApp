//
//  StringPicker.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 14.03.2021.
//

import Foundation

class StringPicker {
    static func searchString(_ string: String) -> String {
        let string = "https://newsapi.org/v2/everything?q=\(string)&apiKey=4495630cd6554dd6beb7903b040611e3"
        return string
    }
}
