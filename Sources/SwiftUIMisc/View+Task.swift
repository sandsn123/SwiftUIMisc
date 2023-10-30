//
//  File.swift
//  
//
//  Created by sandsn on 2023/10/30.
//

import SwiftUI
// perform async task for ios13
extension View {
    public func asyncTask(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View {
        if #available(iOS 15.0, *) {
           return task(priority: priority, action)
        } else {
            var task: Task<Void, Never>?
           return self
                .onAppear {
                    task = Task(priority: priority) {
                        await action()
                    }
                }
                .onDisappear {
                    task?.cancel()
                }
        }
    }
    
    public func asyncTask<T>(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View where T : Equatable {
        if #available(iOS 15.0, *) {
           return task(id: value, priority: priority, action)
        } else {
            var task: Task<Void, Never>?
           return onValueChanged(of: value) { newValue in
                task = Task(priority: priority) {
                    await action()
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
    }
}
