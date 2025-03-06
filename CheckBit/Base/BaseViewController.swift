//
//  BaseViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import UIKit

class BaseViewController: UIViewController{
    
    private(set) var didSetupContraints = false
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureBind()
        
        self.view.setNeedsUpdateConstraints(
        )
    }
    
    override func updateViewConstraints() {
        if !didSetupContraints {
            configureLayout()
            didSetupContraints = true
        }
        super.updateViewConstraints()
    }
    
    func configureHierarchy(){}
    func configureLayout(){}
    func configureView(){}
    func configureBind(){}
}
