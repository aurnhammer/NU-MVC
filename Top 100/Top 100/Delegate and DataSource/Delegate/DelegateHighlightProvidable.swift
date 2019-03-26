//
//  DelegateHighlightProvidable.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
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
