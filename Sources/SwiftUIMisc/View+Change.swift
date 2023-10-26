//
//  File.swift
//  
//
//  Created by czi on 2023/10/24.
//

import Combine
import SwiftUI

public extension View {
    @ViewBuilder
    func onValueChanged<T: Equatable>(of value: T, perform: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: perform)
        } else {
            self.onReceive(Just(value)) { (value) in
                perform(value)
            }
        }
    }
}
