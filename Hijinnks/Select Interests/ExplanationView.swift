//
//  ExplanationView.swift
//  Hijinnks
//
//  Created by adeiji on 3/11/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class ExplanationView : UIView {
    
    weak var explanationLabel:UILabel!
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        setExplanationLabel()
    }
    
    func setExplanationLabel () {
        let explanationLabel = UILabel()
        explanationLabel.text = "Please Select at Least 2 Interests from the List"
        explanationLabel.textColor = .white
        explanationLabel.backgroundColor = Colors.invitationTextGrayColor.value
        explanationLabel.font = UIFont.systemFont(ofSize: 25)
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        self.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
        }
        self.explanationLabel = explanationLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
