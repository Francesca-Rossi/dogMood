//
//  Dao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import Foundation


protocol Dao
{
    associatedtype T
    
    func getAll(info: inout ErrorInfo) async throws -> [T]
    func getById(_ id: UUID, info: inout ErrorInfo) async throws -> T?
    func create(obj: T, info: inout ErrorInfo) async throws
    func update(id: UUID, obj: T, info: inout ErrorInfo) async throws 
    func delete(_ id: UUID, info: inout ErrorInfo) async throws
}
