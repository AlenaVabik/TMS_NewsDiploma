//
//  Extencion+.swift
//  NewsDiploma
//
//  Created by Alena  on 11.03.25.
//
import SwiftUI

extension DateFormatter {
   static let articleDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.locale = Locale(identifier: "en_US_POSIX")
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return formatter
   }()
}
