//
//  BaseViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import UIKit

class BaseViewController<RootView: UIView>: UIViewController {
    
    let rootView: RootView
    
    init() {
        self.rootView = RootView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints()
        configureNavigationBar()
        bindModel()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureConstraints() {
        
    }
    
    func bindModel() {
        
    }
    
    func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        configureNavBarAppearance()
        if let nc = self.navigationController, nc.viewControllers.count > 1 {
            configureNavBarLeftBarButtonItem()
        }
        configureNavBarTitle()
    }
    
    func configureKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        rootView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        rootView.endEditing(true)
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension BaseViewController {
    
    private func configureNavBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .myAppBlack
    }
    
    private func configureNavBarLeftBarButtonItem() {
        let backButtonImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureNavBarTitle() {
        guard let navBarInfo = self.rootView as? NaviProtocol else {
            return
        }
        navigationItem.title = navBarInfo.navigationTitle
    }
    
}
