//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/05.
//

import Foundation

public struct AddPaymentMethodInfo {
	public let number:String
	public let cvc: String
	public let expiry: String

	public init(
		number:String,
		cvc: String,
		expiry: String
	) {
		self.number = number
		self.cvc = cvc
		self.expiry = expiry
	}
}
