//
//  ActionViewController.swift
//  pay
//
//  Created by Damon Yuan on 31/12/2019.
//  Copyright © 2019 Damon Yuan. All rights reserved.
// https://stackoverflow.com/questions/25300194/ios-app-extension-action-custom-data
//

import UIKit
import MobileCoreServices

@objc (ActionViewController)
class ActionViewController: UIViewController {

    var textView: UITextView!
    var doneBtn: UIButton!
    var convertedString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let textItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let textItemProvider = textItem.attachments![0]
        prepareUI()

        if textItemProvider.hasItemConformingToTypeIdentifier("com.damonyuan.host.action") {
            textItemProvider.loadItem(forTypeIdentifier: "com.damonyuan.host.action",
                                      options: nil,
                                      completionHandler: { (result, error) in
                                        let mything = (result as? NSDictionary) as! Dictionary<String, AnyObject>
                                        self.convertedString = mything["mything"] as? String
                                        if let converted = self.convertedString {
                                            DispatchQueue.main.async {
                                                NSLog(converted)
                                                self.textView.text = converted
                                            }
                                        }
          })
        }
    }
    
    private func prepareUI() {
        self.view.backgroundColor = UIColor.red
        
        self.textView = UITextView()
        self.view.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: self.textView!,
                                                                   attribute: .centerX,
                                                                   relatedBy: .equal,
                                                                   toItem: self.view,
                                                                   attribute: .centerX,
                                                                   multiplier: 1,
                                                                   constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.textView!,
                                                                   attribute: .centerY,
                                                                   relatedBy: .equal,
                                                                   toItem: self.view,
                                                                   attribute: .centerY,
                                                                   multiplier: 1,
                                                                   constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.textView!,
                                                            attribute: .width,
                                                                   relatedBy: .equal,
                                                                   toItem: nil,
                                                                   attribute: .width,
                                                                   multiplier: 1,
                                                                   constant: 200))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.textView!,
                                                                   attribute: .height,
                                                                   relatedBy: .equal,
                                                                   toItem: nil,
                                                                   attribute: .height,
                                                                   multiplier: 1,
                                                                   constant: 100))
        
        self.doneBtn = UIButton()
        self.doneBtn.backgroundColor = .green
        self.doneBtn.setTitle("done", for: .normal)
        self.doneBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        self.view.addSubview(self.doneBtn)
        self.doneBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: self.doneBtn!,
                                                                   attribute: .centerX,
                                                                   relatedBy: .equal,
                                                                   toItem: self.view,
                                                                   attribute: .centerX,
                                                                   multiplier: 1,
                                                                   constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.doneBtn!,
                                                        attribute: .topMargin,
                                                        relatedBy: .equal,
                                                        toItem: self.textView,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: 20))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.doneBtn!,
                                                            attribute: .width,
                                                                   relatedBy: .equal,
                                                                   toItem: nil,
                                                                   attribute: .width,
                                                                   multiplier: 1,
                                                                   constant: 100))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.doneBtn!,
                                                                   attribute: .height,
                                                                   relatedBy: .equal,
                                                                   toItem: nil,
                                                                   attribute: .height,
                                                                   multiplier: 1,
                                                                   constant: 50))
    }

    @objc func done() {
        self.convertedString = self.textView.text
        let returnProvider = NSItemProvider(
            item: convertedString as NSSecureCoding?,
            typeIdentifier: "com.damonyuan.host.result")
        let returnItem = NSExtensionItem()
        returnItem.attachments = [returnProvider]
        self.extensionContext!.completeRequest(returningItems: [returnItem], completionHandler: nil)
    }
    
    @objc func cancel() {
        self.extensionContext!.cancelRequest(withError:NSError())
    }
}


