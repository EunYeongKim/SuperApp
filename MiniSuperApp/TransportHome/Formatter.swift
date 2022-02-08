//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by SEUNGHA on 2022/02/08.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
