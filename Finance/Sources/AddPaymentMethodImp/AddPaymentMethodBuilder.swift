//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/05.
//

import ModernRIBs
import FinanceRepository
import RIBsUtil
import AddPaymentMethod

public protocol AddPaymentMethodDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

	var cardsOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

	var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
}

// MARK: - Builder

public final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

    public override init(dependency: AddPaymentMethodDependency) {
        super.init(dependency: dependency)
    }

	public func build(
		withListener listener: AddPaymentMethodListener,
		closeButtonType: DismissButtonType
	) -> ViewableRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
        let viewController = AddPaymentMethodViewController(closeButtonType: closeButtonType)
        let interactor = AddPaymentMethodInteractor(
			presenter: viewController,
			dependency: component
		)
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
