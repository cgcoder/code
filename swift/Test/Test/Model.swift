//
//  Model.swift
//  Test
//
//  Created by Chandrasekaran, Gopinath on 8/15/23.
//

import Foundation

class Model: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
}
