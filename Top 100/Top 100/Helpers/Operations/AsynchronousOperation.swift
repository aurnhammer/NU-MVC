//
//  AsynchronousOperation.swift
//
//  Created by William Aurnhammerurnhammer on 9/21/16.
//  Copyright © 2016 Aurnhammer. All rights reserved.
//

import Foundation

extension NSLock {
	func withCriticalScope<T>(_ block: () -> T) -> T {
		lock()
		let value = block()
		unlock()
		return value
	}
}

/// A Base Operation used to create asynchronous operations.
/// When you call the start() method of an asynchronous operation,
//  that method may return before the corresponding task is completed.
//  By managing and observing the KVO state of the operation, other operations
//  can be queued and populated with data, with the guarantee that subclasses of
//  AsynchronousOperation have completed execution.
open class AsynchronousOperation: Operation {
	
    /// the possible states
    public enum State: Int {
        case executing
        case finished
        case cancelled
    }
    
    // Mark - Private Properties
    
    /// Private storage for the `state` property that will be KVO observed.
    private var _state = State.finished
    
    /// A lock to guard reads and writes to the `_state` property
    private let stateLock = NSLock()
    
    open override var isExecuting: Bool {
        get {
            return state == .executing
        }
    }
    
    open override var isFinished: Bool {
        get {
            return state  ==  .finished || isCancelled
        }
    }
    
    open override var isCancelled: Bool {
        get {
            return state  ==  .cancelled
        }
    }
    
    open var state: State {
        get {
            return stateLock.withCriticalScope {
                _state
            }
        }
        
        set(newState) {
            stateLock.withCriticalScope { () -> Void in
                guard _state != .finished else {
                    return
                }
                willChangeValue(forKey: "state")
                _state = newState
                didChangeValue(forKey: "state")
            }
            
        }
    }
    
    // MARK - Class Function
    
    // use the KVO mechanism to indicate that changes to "state" affect other properties as well
	class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
		return ["state" as NSObject]
	}
	
	class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
		return ["state" as NSObject]
	}
	
	class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
		return ["state" as NSObject]
	}

	open func state(_ state: State) {
		self.state = state
	}
	
	open override var isAsynchronous: Bool {
		get {
			return true
		}
	}
	
	open override func start() {
		guard !isCancelled else {
			state(.cancelled)
			return
		}
		state(.executing)
		// If the operation is not canceled, begin executing the task.
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
			self.main()
		}
	}
}
