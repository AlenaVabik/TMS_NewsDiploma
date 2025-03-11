//
//  ProcessInfo.swift
//  NewsDiploma
//
//  Created by Alena  on 11.03.25.
//
import SwiftUI

extension ProcessInfo {
    static var isPreviewMode: Bool {
        if let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"], isPreview == "1" {
            return true
        } else {
            return false
        }
    }
}
