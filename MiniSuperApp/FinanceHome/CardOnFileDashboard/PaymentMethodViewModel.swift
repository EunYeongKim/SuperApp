//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/04.
//

import UIKit

struct PaymentMethodViewModel {
	let name: String
	let digits: String
	let color: UIColor

	init(_ paymentMethod: PaymentMethod) {
		name = paymentMethod.name
		digits = "**** \(paymentMethod.digits)"
		color = UIColor(hex: paymentMethod.color) ?? .systemGray2
	}
}
