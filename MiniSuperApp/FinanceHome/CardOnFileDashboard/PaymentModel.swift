//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import Foundation

struct PaymentMethod: Decodable {
	let id: String
	let name: String
	let digits: String
	let color: String
	let isPrimary: Bool
}
