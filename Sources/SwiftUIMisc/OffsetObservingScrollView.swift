//
//  OffsetObservingScrollView.swift
//  Audiomixer
//
//  Created by czi on 2023/10/23.
//

import SwiftUI


struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            // No-op
        }
    }
}

public struct OffsetObservingScrollView<Content: View>: View {
    var axes: Axis.Set = [.vertical]
    var showsIndicators = true
    @Binding public var offset: CGPoint
    @ViewBuilder public var content: () -> Content
    
    public init(axes: Axis.Set = .horizontal, showsIndicators: Bool = true, offset: Binding<CGPoint>, content: @escaping () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset
        self.content = content
    }
    
    // The name of our coordinate space doesn't have to be
    // stable between view updates (it just needs to be
    // consistent within this view), so we'll simply use a
    // plain UUID for it:
    private let coordinateSpaceName = UUID()
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                content: content
            )
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}
