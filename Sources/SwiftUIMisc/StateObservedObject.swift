//
//  File.swift
//  
//
//  Created by czi on 2023/10/24.
//

import Combine
import SwiftUI

@available(iOS 13.0, *)
@propertyWrapper
public struct StateObservedObject<T: ObservableObject>: DynamicProperty {
    @State @Lazy private var object: T
    @ObservedObject private var updater = StateObservedObjectUpdater()

    @dynamicMemberLookup public struct Wrapper {
        let value: T
        let update: () -> Void

        public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Subject>) -> Binding<Subject> {
            .init(
                get: { value[keyPath: keyPath] },
                set: {
                    value[keyPath: keyPath] = $0
                    update()
                }
            )
        }
    }

    public var projectedValue: Wrapper {
        .init(value: object, update: _updater.wrappedValue.objectWillChange.send)
    }

    public var wrappedValue: T {
        get {
            object
        }
        set {
            object = newValue
        }
    }

    public init(wrappedValue: @autoclosure @escaping () -> T) {
        self._object = State(wrappedValue: Lazy(wrappedValue))
    }

    // NOTE: - DynamicPropertyのViewが更新される直前に呼ばれるメソッド
    public mutating func update() {
        // Stateはupdateの中で直前のインスタンスに置き換えているので、置き換えた後（つまり一番最初に作られれたインスタンス）の中のupdaterのみを置き換え
        _object.wrappedValue.update = _updater.wrappedValue.objectWillChange.send
    }
}

@available(iOS 13.0, *)
extension StateObservedObject {
    @propertyWrapper
    private class Lazy {
        let lazyValue: () -> T
        var cached: T?
        var update: (() -> Void)?
        private var cancellableSet: Set<AnyCancellable> = []

        init(_ value: @escaping () -> T) {
            lazyValue = value
        }

        var wrappedValue: T {
            get {
                if let cached = cached {
                    return cached
                }
                cached = lazyValue()
                cached?
                    .objectWillChange
                    .sink { [weak self] _ in
                        self?.update?()
                    }
                    .store(in: &cancellableSet)

                return cached!
            }
            set {
                cached = newValue
            }
        }
    }
}

@available(iOS 13.0, *)
private class StateObservedObjectUpdater: ObservableObject {
}

@available(iOS 13.0, *)
final class Counter: ObservableObject {
    @Published var number = 0
}


@available(iOS 13.0.0, *)
struct SwiftUIPlayGroundView: View {
    @StateObservedObject var counter = Counter()

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Text("TopObject")
                Spacer()
                Text("\(counter.number)")
                Button(action: {
                    counter.number += 1
                }) {
                    ZStack {
                        Color.blue
                            .frame(width: 32, height: 32, alignment: .center)
                        Text("＋")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
            }
            ObservedCounterView()
            StateCounterView()
            BindingCounterView(counter: counter)
        }
        .padding(.all, 16)
    }
}

@available(iOS 13.0.0, *)
struct ObservedCounterView: View {
    @ObservedObject var counter = Counter()

    var body: some View {
        HStack {
            Text("ObservedObject")
            Spacer()
            Text("\(counter.number)")
            Button(action: {
                counter.number += 1
            }) {
                ZStack {
                    Color.blue
                        .frame(width: 32, height: 32, alignment: .center)
                    Text("＋")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct StateCounterView: View {
    @StateObservedObject var counter = Counter()

    var body: some View {
        HStack {
            Text("StateObject")
            Spacer()
            Text("\(counter.number)")
            Button(action: {
                counter.number += 1
            }) {
                ZStack {
                    Color.blue
                        .frame(width: 32, height: 32, alignment: .center)
                    Text("＋")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct BindingCounterView: View {
    @ObservedObject var counter: Counter

    var body: some View {
        HStack {
            Text("BindingObject")
            Spacer()
            Text("\(counter.number)")
            Button(action: {
                counter.number += 1
            }) {
                ZStack {
                    Color.blue
                        .frame(width: 32, height: 32, alignment: .center)
                    Text("＋")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    Group {
        SwiftUIPlayGroundView()
        
        ObservedCounterView()
    }
}
