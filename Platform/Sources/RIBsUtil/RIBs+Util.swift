//
//  File.swift
//  
//
//  Created by 60080252 on 2022/02/07.
//

import Foundation

public enum DismissButtonType {
	case back, close

	public var iconSystemName: String {
		switch self {
			case .back:
				return "chevron.backward"
			case .close:
				return "xmark"
		}
	}
}
