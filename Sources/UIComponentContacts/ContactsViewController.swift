//
//  ContactsViewController.swift
//  
//
//  Created by X Tommy on 2023/1/30.
//

import UIKit
import Parchment

public class ContactsViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
    }
    
}

extension ContactsViewController {
    
    private func configureHierarchy() {
       
        let viewControllers = [
            ContactsListViewController(query: ContactsQuery(type: .followers)),
            ContactsListViewController(query: ContactsQuery(type: .following)),
        ]
        
        let pagingViewController = PagingViewController(viewControllers: viewControllers)
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.view.bounds = view.bounds
        
//        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        print("debug:ContactsViewController:configureHierarchy")
    }
    
}
