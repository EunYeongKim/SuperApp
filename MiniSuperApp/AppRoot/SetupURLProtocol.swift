//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by SEUNGHA on 2022/02/11.
//

import Foundation

func setupURLProtocol() {
    // Topup
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    // AddCard
    let addCardResponse: [String: Any] = [
        "card": [
            "id": "999",
            "name": "새카드",
            "digits": "**** 0101",
            "color": "",
            "isPrimary": false
        ]
    ]
    
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
    
    // CardOnFile
    let cardOnFileResponse: [String: Any] = [
        "cards": [
//            [
//                "id": "0",
//                "name": "우리은행",
//                "digits": "0123",
//                "color": "#f19a38ff",
//                "isPrimary": false
//            ],
//            [
//                "id": "1",
//                "name": "현대카드",
//                "digits": "8121",
//                "color": "#78c5f5ff",
//                "isPrimary": false
//            ],
            [
                "id": "2",
                "name": "신한카드",
                "digits": "0987",
                "color": "#3478f6ff",
                "isPrimary": false
            ],
            [
                "id": "3",
                "name": "국민은행",
                "digits": "2812",
                "color": "#65c466ff",
                "isPrimary": false
            ],
            [
                "id": "4",
                "name": "카카오뱅크",
                "digits": "8751",
                "color": "#ffcc00ff",
                "isPrimary": false
            ]
        ]
    ]
    
    let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData),
        "/api/v1/addCard": (200, addCardResponseData),
        "/api/v1/cards": (200, cardOnFileResponseData)
    ]
}
