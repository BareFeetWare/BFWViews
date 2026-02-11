//
//  Task+Sleep.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/3/2024.
//

public extension Task where Failure == Never, Success == Never {
    
    static func sleep(seconds: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(seconds * 1e9))
    }
    
}

