//
//  PresentationController.swift
//  Top 30
//
//  Created by William Aurnhammerurnhammer on 1/9/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit


/// Manages custom presentation and dismisal of view controllers
/// with the presented view controller appearing over the presenting view controller
/// as an overlay.
class PresentationController: UIPresentationController {
    
    // MARK: - Private properties
    private var dimmingView: UIView = UIView()
    
    // MARK: - Initialization
    public override init(presentedViewController: UIViewController,
                         presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        dimmingView.accessibilityIgnoresInvertColors = true
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(dimmingViewTapped)))
    }
    
    deinit {
        Log.message("Deinit", enabled: false)
    }
    
    // MARK: - Private functions
    @objc private func dimmingViewTapped(sender: UITapGestureRecognizer)  {
        presentingViewController.dismiss(animated: true)
    }
    
    // MARK: - Protocol Conformance
    override open func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0.0
        
        containerView.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self]
            context in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override open func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            context in
            self.dimmingView.alpha = 0.0
        }, completion: { [unowned self] _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    override open func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === presentedViewController {
            containerView?.setNeedsLayout()
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.frame.size = size
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        })
    }
    
    override open func size(forChildContentContainer container: UIContentContainer,
                            withParentContainerSize parentSize: CGSize) -> CGSize {
        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let iPadWidth = 600
            let iPadHeight = 600
            let rect = CGRect(x: 0, y: 0, width: iPadWidth, height:iPadHeight)
            let xOffset = ((containerView?.bounds.width ?? CGRect.zero.width) - rect.width) / 2.0
            let yOffset = ((containerView?.bounds.height ?? CGRect.zero.height) - rect.height) / 2.0
            return CGRect(x: xOffset, y: yOffset, width: rect.width, height: rect.height)
        default:
            let margin: CGFloat = 32
            let maximumHeight: CGFloat = 600
            let height = containerView?.bounds.height ?? 0
            let width = containerView?.bounds.width ?? 0
            let offsetY: CGFloat = ((height - (margin * 2)) > maximumHeight) ? (height - maximumHeight)/2.0 : margin
            let offsetX: CGFloat = ((width - (margin * 2)) > maximumHeight) ? (width - maximumHeight)/2.0 : margin
            return containerView?.bounds.insetBy(dx: offsetX, dy: offsetY) ?? CGRect.zero
        }
    }
    
}
