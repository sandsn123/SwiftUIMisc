//
//  LoadingButton.swift
//  CZI_Official
//
//  Created by czi on 2023/10/10.
//

import SwiftUI

public struct LoadingButton<Label: View, BgView: View> : View {
    public var action: () -> Void
    public var label: Label
    public var background: BgView
    public var isLoading: Bool
    
    public init(isLoading: Bool, action: @escaping () -> Void,
                @ViewBuilder label: @escaping () -> Label,
                @ViewBuilder background: @escaping () -> BgView) {
        self.isLoading = isLoading
        self.action = action
        self.label = label()
        self.background = background()
    }

    @MainActor public var body: some View {
        Button(action: action, label: {
            if BgView.self == EmptyView.self {
                stateView
            } else {
                background
                    .overlay(
                        stateView
                    )
            }
        })
    }
    
    @ViewBuilder
    var stateView: some View {
        if isLoading {
            ActivityIndicator()
        } else {
            label
        }
    }
}

extension LoadingButton where BgView == EmptyView {
    public init(isLoading: Bool, action: @escaping () -> Void,
                @ViewBuilder label: @escaping () -> Label) {
        self.isLoading = isLoading
        self.action = action
        self.label = label()
        self.background = EmptyView()
    }
}


#Preview {
    LoadingButton(isLoading: false) {
        
    } label: {
        Text("注册")
            .foregroundColor(.blue)
            .font(.system(size: 15, weight: .medium))
    }
//    .frame(maxWidth: .infinity, maxHeight: 45)
//    .padding(.horizontal)
}


