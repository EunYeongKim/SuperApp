//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/07.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
	var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency {
	var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }

    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener

		let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)

        return TopupRouter(
			interactor: interactor,
			viewController: component.topupBaseViewController,
			addPaymentMethodBuildable: addPaymentMethodBuilder
		)
    }
}
