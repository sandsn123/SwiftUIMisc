//
//  ActivityIndicator.swift
//  CZI_Official
//
//  Created by czi on 2023/10/13.
//

import SwiftUI

@available(iOS 13, *)
public struct LSProgressView: UIViewRepresentable {
    public var color: UIColor = .white
    public var style: UIActivityIndicatorView.Style = .medium
    public func makeUIView(context: UIViewRepresentableContext<LSProgressView>) -> UIActivityIndicatorView {
        
        let progressView = UIActivityIndicatorView(style: style)
        progressView.color = color
        progressView.startAnimating()
        
        return progressView
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LSProgressView>) {
    }
}

public struct ActivityIndicator: View {
    public enum Style {
        case mini
        case medium
        case large
        
        var uiStytle: UIActivityIndicatorView.Style {
            switch self {
            case .mini:
                return .medium
            case .medium:
                return .medium
            case .large:
                return .large
            }
        }
        
        @available(iOS 15.0, *)
        var size: ControlSize {
            switch self {
            case .mini:
                return .mini
            case .medium:
                return .small
            case .large:
                return .regular
            }
        }
    }
    public var style: Style = .mini
    public var color: UIColor = .white
    public var body: some View {
        if #available(iOS 15.0, *) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(color)))
                .controlSize(style.size)
        } else {
            LSProgressView(color: color, style: style.uiStytle)
        }
    }
}

