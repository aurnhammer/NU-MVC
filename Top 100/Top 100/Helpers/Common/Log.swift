//
//  Log.swift
//
//  Created by William Aurnhammerurnhamer on 7/17/16.
//  Copyright © 2016 Aurnhammer. All rights reserved.
//

import Foundation
import UIKit


/// A replaceent for NSLog. Used for reporting back to the console and through alerts messages.
/// Log messages will not diplay in release apps.
public struct Log {
	
	static var operationQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		return queue
	}()
	
    
    /// A static funtion to log Errors to the Console or present UIAlerts.
    ///
    /// - Parameters:
    ///   - lineNumber: Use #line.
    ///   - functionName: Use #function.
    ///   - error: An Error
    ///   - enabled: Bool Value to enable or disable viewing in console. Defaults to true.
    ///   - alert: Bool Value to enable or disable presentation of Alerts. Defaults to true.
	public static func error(with lineNumber: Int, functionName: String, error: Error?, enabled: Bool = true, alert: Bool = true) {
		#if !RELEASE
		if enabled == true {
			if let error: NSError = error as NSError? {
				var messageString: String = "ERROR [\(error.domain): \(error.code) \(error.localizedDescription)]"
				if error.localizedFailureReason != nil {
					messageString.append(" \(String(describing: error.localizedFailureReason))")
				}
				if error.userInfo[NSUnderlyingErrorKey] != nil {
					messageString.append(" \(String(describing: error.userInfo[NSUnderlyingErrorKey]))")
				}
				if error.localizedRecoverySuggestion != nil {
					messageString.append(" \(String(describing: error.localizedRecoverySuggestion))")
				}
				messageString.append(" \(functionName) — \(lineNumber)]\n")
				message(messageString, alert:alert)
			}
		}
		#endif
	}
	
    /// A static funtion to log messages as strings to the Console or diplay UIAlerts.
    ///
    /// - Parameters:
    //
    ///   - string: String value for the message.
    ///   - enabled: Bool Value to enable or disable viewing in console. Defaults to true.
    ///   - alert: Bool Value to enable or disable presentation of Alerts. Defaults to true.
	public static func message(_ string: String, enabled: Bool = true, alert: Bool = false) {
		#if !RELEASE
		if enabled == true || operationQueue.operationCount > 0 {
			let dateFormatter: DateFormatter = DateFormatter()
			dateFormatter.dateFormat = "h:mm:ss.SSS"
			let dateString = dateFormatter.string(from: Date())
			print("\n\(dateString) — \(string)")
		}
		
		if alert == true {
			operationQueue.addOperation {
				let group = DispatchGroup()
				group.enter()
				DispatchQueue.main.async {
					
					let message = string
					let alertController = UIAlertController(
						title: "Warning",
						message: message,
						preferredStyle: .alert)
					
					alertController.addAction(UIAlertAction(title: "Okay", style: .default) {_ in
						group.leave()
					})
					if let
						appDelegate:UIApplicationDelegate = UIApplication.shared.delegate,
						let window = appDelegate.window,
						let rootViewController = window!.rootViewController {
						rootViewController.present(alertController, animated: true, completion: nil)
					}
				}
				// Wait until the alert is dismissed by the user tapping on the OK button.
				group.wait()
			}
		}
		#endif
	}
}


