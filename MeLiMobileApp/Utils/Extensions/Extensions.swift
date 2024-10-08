//
//  Extensions.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 7/10/24.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
