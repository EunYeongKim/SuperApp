//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by SEUNGHA on 2022/02/11.
//

import Foundation

func setupURLProtocol() {
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData)
    ]
}
