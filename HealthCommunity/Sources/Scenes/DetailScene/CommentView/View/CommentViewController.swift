//
//  CommentViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit

final class CommentViewController: BaseViewController<CommentView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
        
    }
    
}
