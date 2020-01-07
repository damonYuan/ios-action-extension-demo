//
//  ViewController.swift
//  vendor
//
//  Created by Damon Yuan on 31/12/2019.
//  Copyright © 2019 Damon Yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textfiled: UITextField!

    @IBAction func action() {
        let mything = [
            "mything": self.textfiled.text!,
            ] as [String : Any]
        let item = NSExtensionItem()
        let attachment = NSItemProvider(item: mything as NSSecureCoding, typeIdentifier: "com.damonyuan.host.action")
        item.attachments = [attachment]
        let vc = UIActivityViewController(
            activityItems: [item],
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            guard (activityType?.rawValue == "com.damonyuan.host.action") else {
                NSLog("something went wrong")
                return
            }
            if let _ = error {
                NSLog("something went wrong")
                return
            }
            
            if completed {
                let returnedItem = returnedItems?[0] as? NSExtensionItem
                let returnedItemProvider = returnedItem?.attachments?[0]
                if let nnReturnedItemProvider = returnedItemProvider {
                    if  nnReturnedItemProvider.hasItemConformingToTypeIdentifier("com.damonyuan.host.result") {
                        nnReturnedItemProvider.loadItem(forTypeIdentifier: "com.damonyuan.host.result",
                        options: nil,
                        completionHandler: { (result, error) in
                          let returned = result as? String
                          if let nnReturned = returned {
                              DispatchQueue.main.async {
                                  NSLog(nnReturned)
                                  self.textfiled.text = nnReturned
                              }
                          }
                        })
                    }
                }
            }
            
        }
        
        self.present(vc, animated: true, completion: nil)
    }

}

