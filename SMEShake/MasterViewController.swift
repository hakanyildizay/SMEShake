//
//  MasterViewController.swift
//  SMEShake
//
//  Created by Hakan Yildizay [Mobil Yazilim  Servisi] on 09/06/2017.
//  Copyright © 2017 ING BANK. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
           }

    override var canBecomeFirstResponder: Bool {
            return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        guard let motionEvent = event else { return }
        
        if motionEvent.type == .motion {
            self.go()
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func go() {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }

 

}

