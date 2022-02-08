//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import Foundation

struct Formatter {
	static let balanceFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()
}
