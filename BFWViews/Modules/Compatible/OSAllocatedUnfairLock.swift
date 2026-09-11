//
//  OSAllocatedUnfairLock.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/8/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import os

/// Backward compatibility implementation of OSAllocatedUnfairLock (iOS 16+), with the same API. On iOS 16 and later every operation forwards to Apple's implementation; below that it guards `State` with an `os_unfair_lock` held in a `ManagedBuffer`, as Apple's own implementation does. The `Unchecked` members drop the `Sendable` requirements, for state whose thread safety the compiler cannot verify, such as Core Foundation types.
public struct OSAllocatedUnfairLock<State> {
    private let storage: Storage
    
    public init(uncheckedState initialState: State) {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            storage = NativeStorage(initialState)
        } else {
            storage = FallbackStorage(initialState)
        }
    }
}

// MARK: - Convenience Inits

public extension OSAllocatedUnfairLock where State: Sendable {
    
    init(initialState: State) {
        self.init(uncheckedState: initialState)
    }
}

public extension OSAllocatedUnfairLock where State == Void {
    
    init() {
        self.init(uncheckedState: ())
    }
}

// MARK: - Types

extension OSAllocatedUnfairLock {
    
    /// Abstract. Each subclass implements the same operations against one era's lock.
    class Storage {
        
        func withLockUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result {
            fatalError("Storage subclasses implement withLockUnchecked")
        }
        
        func withLockIfAvailableUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result? {
            fatalError("Storage subclasses implement withLockIfAvailableUnchecked")
        }
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    final class NativeStorage: Storage {
        private let lock: os.OSAllocatedUnfairLock<State>
        
        init(_ initialState: State) {
            lock = .init(uncheckedState: initialState)
            super.init()
        }
        
        override func withLockUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result {
            try lock.withLockUnchecked(body)
        }
        
        override func withLockIfAvailableUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result? {
            try lock.withLockIfAvailableUnchecked(body)
        }
    }
    
    final class FallbackStorage: Storage {
        private let buffer: ManagedBuffer<State, os_unfair_lock>
        
        init(_ initialState: State) {
            buffer = .create(minimumCapacity: 1) { buffer in
                buffer.withUnsafeMutablePointerToElements { lock in
                    lock.initialize(to: os_unfair_lock())
                }
                return initialState
            }
            super.init()
        }
        
        override func withLockUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result {
            try buffer.withUnsafeMutablePointers { state, lock in
                os_unfair_lock_lock(lock)
                defer { os_unfair_lock_unlock(lock) }
                return try body(&state.pointee)
            }
        }
        
        override func withLockIfAvailableUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result? {
            try buffer.withUnsafeMutablePointers { state, lock -> Result? in
                guard os_unfair_lock_trylock(lock)
                else { return nil }
                defer { os_unfair_lock_unlock(lock) }
                return try body(&state.pointee)
            }
        }
    }
}

// MARK: - Protocol Implementations

extension OSAllocatedUnfairLock: @unchecked Sendable {}

// MARK: - Functions

public extension OSAllocatedUnfairLock {
    
    func withLockUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result {
        try storage.withLockUnchecked(body)
    }
    
    func withLock<Result: Sendable>(_ body: @Sendable (inout State) throws -> Result) rethrows -> Result {
        try storage.withLockUnchecked(body)
    }
    
    /// Returns nil without running `body` when the lock is already held.
    func withLockIfAvailableUnchecked<Result>(_ body: (inout State) throws -> Result) rethrows -> Result? {
        try storage.withLockIfAvailableUnchecked(body)
    }
    
    func withLockIfAvailable<Result: Sendable>(_ body: @Sendable (inout State) throws -> Result) rethrows -> Result? {
        try storage.withLockIfAvailableUnchecked(body)
    }
}

public extension OSAllocatedUnfairLock where State == Void {
    
    func withLockUnchecked<Result>(_ body: () throws -> Result) rethrows -> Result {
        try storage.withLockUnchecked { _ in try body() }
    }
    
    func withLock<Result: Sendable>(_ body: @Sendable () throws -> Result) rethrows -> Result {
        try storage.withLockUnchecked { _ in try body() }
    }
    
    func withLockIfAvailableUnchecked<Result>(_ body: () throws -> Result) rethrows -> Result? {
        try storage.withLockIfAvailableUnchecked { _ in try body() }
    }
    
    func withLockIfAvailable<Result: Sendable>(_ body: @Sendable () throws -> Result) rethrows -> Result? {
        try storage.withLockIfAvailableUnchecked { _ in try body() }
    }
}
