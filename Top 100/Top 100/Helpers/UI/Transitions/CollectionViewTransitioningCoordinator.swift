//
//  CollectionViewTransitioningCoordinator.swift
//  Top 30
//
//  Created by William Aurnhammer on 1/11/19.
//  Copyright © 2019 Aurnhammer All rights reserved.
//

import UIKit

/// An animated transition that displays the presented view controller in flip animation from the selected cell.
class ViewControllerTransitioningCoordinator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Private Properties
    static private var animationDuration: TimeInterval = 0.63
    private var indexPath: IndexPath!
    private var view: SequenceViewer!
    
    // MARK: - Initialization
    init(with view: SequenceViewer, for selectedItems: IndexPath) {
        super.init()
        self.view = view
        self.indexPath = selectedItems
    }
    
    deinit {
        Log.message("deinit CollectionViewTransitioningCoordinator", enabled: true)
    }
    
    // MARK: - Protocol conformance
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let transitionContext = transitionContext else {
            return 0
        }
        return transitionContext.isAnimated ? ViewControllerTransitioningCoordinator.animationDuration : 0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toViewController.view,
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromViewController.view,
            var cell = view.sequenceCell(at: indexPath)
            else {
                return
        }
        let containerView: UIView = transitionContext.containerView
        let isPresenting = containerView.subviews.count == 1
        
        if isPresenting {
            UIGraphicsBeginImageContext(cell.bounds.size)
            cell.isSelected = false
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            containerView.addSubview(UIImageView(image: image))
            containerView.addSubview(toView)
        }
        else {
            view.deselectItem(at: indexPath, animated: true)
        }
        let startView = isPresenting ? containerView.subviews[1] : fromView
        let endView = isPresenting ? toView : containerView.subviews[1]
        var animatingView = startView
        
        let cellRect = cell.frame
        let fromViewFinalFrame = view.convert(cellRect, to: containerView)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        endView.frame = toViewFinalFrame
        endView.alpha = isPresenting ? 0 : 1
        
        let fromFrame = isPresenting ? fromViewFinalFrame : toViewFinalFrame
        
        // Change the z position so the animation happens above the dimming view.
        animatingView.layer.zPosition = 1000
        
        var startSizeTransform = CATransform3DIdentity
        startSizeTransform.m34 = -0.001
        startSizeTransform = CATransform3DTranslate(startSizeTransform, fromFrame.minX, fromFrame.minY, 0)
        
        var endSizeTransform = CATransform3DIdentity
        endSizeTransform.m34 = -0.001
        endSizeTransform = CATransform3DRotate(endSizeTransform, CGFloat(90 * Double.pi / 180), 0, 1, 0)
        if !isPresenting {
            endSizeTransform = CATransform3DScale(endSizeTransform, 0.63, 0.63, 1)
        }
        
        var startFlipTransfrom = CATransform3DIdentity
        startFlipTransfrom.m34 = -0.001
        startFlipTransfrom = CATransform3DRotate(startFlipTransfrom, CGFloat(270 * Double.pi / 180), 0, 1, 0)
        
        var endFlipTransform = CATransform3DIdentity
        endFlipTransform = CATransform3DRotate(endFlipTransform, CGFloat(360 * Double.pi / 180), 0, 1, 0)
        
        animatingView.layer.transform = isPresenting ? startSizeTransform : endFlipTransform
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: transitionDuration, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                if isPresenting {
                    animatingView.frame = toViewFinalFrame
                }
                animatingView.layer.transform = isPresenting ? endSizeTransform : startFlipTransfrom
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0, animations: {
                animatingView = endView
                animatingView.layer.zPosition = 1000
                startView.alpha = 0
                endView.alpha = 1
                animatingView.layer.transform = isPresenting ? startFlipTransfrom : endSizeTransform
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                if !isPresenting {
                    animatingView.frame = fromViewFinalFrame
                }
                animatingView.layer.transform = isPresenting ? endFlipTransform : startSizeTransform
            })
            
        }) { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
         }
    }
 }

/// MARK: - UIViewControllerTransitioningDelegate
extension ViewControllerTransitioningCoordinator: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

///// An animated transition that displays the presented view controller in flip animation from the selected cell.
//class TableViewTransitioningCoordinator: NSObject, UIViewControllerAnimatedTransitioning {
//
//    // MARK: - Private Properties
//    static private var animationDuration: TimeInterval = 0.63
//    private var indexPath: IndexPath!
//    private var view: UITableView!
//
//    // MARK: - Initialization
//    init(with view: UITableView, for selectedItems: IndexPath) {
//        super.init()
//        self.view = view
//        self.indexPath = selectedItems
//    }
//
//    deinit {
//        Log.message("deinit CollectionViewTransitioningCoordinator", enabled: true)
//    }
//
//
//    // MARK: - Protocol conformance
//    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        guard let transitionContext = transitionContext else {
//            return 0
//        }
//        return transitionContext.isAnimated ? TableViewTransitioningCoordinator.animationDuration : 0
//    }
//
//    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
//            let toView = toViewController.view,
//            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
//            let fromView = fromViewController.view,
//            let cell = view.cellForRow(at: indexPath)
//            else {
//                return
//        }
//        let containerView: UIView = transitionContext.containerView
//        let isPresenting = containerView.subviews.count == 1
//
//        if isPresenting {
//            UIGraphicsBeginImageContext(cell.bounds.size)
//            cell.isSelected = false
//            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            containerView.addSubview(UIImageView(image: image))
//            containerView.addSubview(toView)
//        }
//        else {
//            view.deselectRow(at: indexPath, animated: true)
//        }
//        let startView = isPresenting ? containerView.subviews[1] : fromView
//        let endView = isPresenting ? toView : containerView.subviews[1]
//        var animatingView = startView
//        let cellRect = cell.frame
//        let fromViewFinalFrame = view.convert(cellRect , to: containerView)
//        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
//        endView.frame = toViewFinalFrame
//        endView.alpha = isPresenting ? 0 : 1
//
//        let fromFrame = isPresenting ? fromViewFinalFrame : toViewFinalFrame
//
//        // Change the z position so the animation happens above the dimming view.
//        animatingView.layer.zPosition = 1000
//
//        var startSizeTransform = CATransform3DIdentity
//        startSizeTransform.m34 = -0.001
//        startSizeTransform = CATransform3DTranslate(startSizeTransform, fromFrame.minX, fromFrame.minY, 0)
//
//        var endSizeTransform = CATransform3DIdentity
//        endSizeTransform.m34 = -0.001
//        endSizeTransform = CATransform3DRotate(endSizeTransform, CGFloat(90 * Double.pi / 180), 0, 1, 0)
//        if !isPresenting {
//            endSizeTransform = CATransform3DScale(endSizeTransform, 0.63, 0.63, 1)
//        }
//
//        var startFlipTransfrom = CATransform3DIdentity
//        startFlipTransfrom.m34 = -0.001
//        startFlipTransfrom = CATransform3DRotate(startFlipTransfrom, CGFloat(270 * Double.pi / 180), 0, 1, 0)
//
//        var endFlipTransform = CATransform3DIdentity
//        endFlipTransform = CATransform3DRotate(endFlipTransform, CGFloat(360 * Double.pi / 180), 0, 1, 0)
//
//        animatingView.layer.transform = isPresenting ? startSizeTransform : endFlipTransform
//
//        let transitionDuration = self.transitionDuration(using: transitionContext)
//
//        UIView.animateKeyframes(withDuration: transitionDuration, delay: 0, options: [], animations: {
//
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
//                if isPresenting {
//                    animatingView.frame = toViewFinalFrame
//                }
//                animatingView.layer.transform = isPresenting ? endSizeTransform : startFlipTransfrom
//            })
//
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0, animations: {
//                animatingView = endView
//                animatingView.layer.zPosition = 1000
//                startView.alpha = 0
//                endView.alpha = 1
//                animatingView.layer.transform = isPresenting ? startFlipTransfrom : endSizeTransform
//            })
//
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
//                if !isPresenting {
//                    animatingView.frame = fromViewFinalFrame
//                }
//                animatingView.layer.transform = isPresenting ? endFlipTransform : startSizeTransform
//            })
//
//        }) { (finished) in
//            let wasCancelled = transitionContext.transitionWasCancelled
//            transitionContext.completeTransition(!wasCancelled)
//        }
//    }
//}
//
///// MARK: - UIViewControllerTransitioningDelegate
//extension TableViewTransitioningCoordinator: UIViewControllerTransitioningDelegate {
//
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
//
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
//
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return PresentationController(presentedViewController: presented, presenting: presenting)
//    }
//
//}
//
