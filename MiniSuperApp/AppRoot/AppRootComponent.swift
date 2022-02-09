//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by SEUNGHA on 2022/02/09.
//

import Foundation
import ModernRIBs
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import TransportHome
import TransportHomeImp

final class AppRootComponent: Component<AppRootDependency>,
                              AppHomeDependency,
                              FinanceHomeDependency,
                              ProfileHomeDependency,
                              TransportHomeDependency {
    var cardsOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    init(
        dependency: AppRootDependency,
        cardsOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository
    ) {
        self.cardsOnFileRepository = cardsOnFileRepository
        self.superPayRepository = superPayRepository
        
        super.init(dependency: dependency)
    }
}
