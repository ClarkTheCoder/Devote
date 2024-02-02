//
//  HideKeyboardExt.swift
//  Devote
//
//  Created by Carson Clark on 2024-02-02.
//

import SwiftUI

#if canImport(UIKit)
// dismiss keyboard when we decide to run func
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
