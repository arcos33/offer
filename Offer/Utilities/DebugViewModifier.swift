//
//  DebugViewModifier.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

import SwiftUI

struct DraggableDebugViewName: ViewModifier {
    var name: String
    @State private var offset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .overlay(
                Text(name)
                    .font(.caption)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                    )
                    .padding(),
                alignment: .topLeading
            )
    }
}

extension View {
    public func draggableDebugViewName(_ name: String) -> some View {
        self.modifier(DraggableDebugViewName(name: name))
    }
}

struct DebugEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    public var debugViewName: String {
        get { self[DebugEnvironmentKey.self] }
        set { self[DebugEnvironmentKey.self] = newValue }
    }
}
