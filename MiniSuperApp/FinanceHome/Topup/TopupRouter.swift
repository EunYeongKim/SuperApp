//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/07.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }

	var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
	private var navigationControllable: NavigationControllerable?

	private let addPaymentMethodBuildable: AddPaymentMethodBuildable
	private var addPaymentMethodRouting: Routing?

    init(
		interactor: TopupInteractable,
		viewController: ViewControllable,
		addPaymentMethodBuildable: AddPaymentMethodBuildable
	) {
		self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
		if viewController.uiviewController.presentedViewController != nil,
		   navigationControllable != nil {
			navigationControllable?.dismiss(completion: nil)
		}
    }

	func attachAddPaymentMethod() {
		if addPaymentMethodRouting != nil {
			return
		}

		let router = addPaymentMethodBuildable.build(withListener: interactor)
		presentInsideNavigation(router.viewControllable)
		attachChild(router)

		addPaymentMethodRouting = router
	}

	func detachAddPaymentMethod() {
		guard let router = addPaymentMethodRouting else {
			return
		}
		dismissPresentedNavigation(completion: nil)
		detachChild(router)

		addPaymentMethodRouting = nil
	}

    // MARK: - Private
    private let viewController: ViewControllable

	private func presentInsideNavigation(_ viewControllable: ViewControllable) {
		let navigation = NavigationControllerable(root: viewControllable)
		navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy

		self.navigationControllable = navigation

		viewController.present(navigation, animated: true, completion: nil)
	}

	private func dismissPresentedNavigation(completion: (() -> Void)?) {
		if self.navigationControllable == nil {
			return
		}

		viewController.dismiss(completion: completion)
		self.navigationControllable = nil
	}
}
