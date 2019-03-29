//
//  DelegateHighlightProvidable.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

public protocol DelegateHighlightProvideable: DelegateProvidable {
    func didHighlight(itemAt indexPath: IndexPath)
    func didUnhighlight(itemAt indexPath: IndexPath)
}

extension DelegateHighlightProvideable {
    func didHighlight(itemAt indexPath: IndexPath) {}
    func didUnhighlight(itemAt indexPath: IndexPath) {}
}
