//
//  Constant.swift
//  Devote
//
//  Created by Carson Clark on 2024-02-02.
//

import Foundation
import SwiftUI

// MARK: - placeholder
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
