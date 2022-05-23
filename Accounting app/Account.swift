//
//  Account.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/19.
//

import RealmSwift

class Account: Object{
    
    @objc dynamic var id = 0
    
    @objc dynamic var spend = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var date = ""
    
    @objc dynamic var category = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func totalAccount(){
        
    }
}
