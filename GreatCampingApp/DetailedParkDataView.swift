//
//  DetailedView.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/24/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import UIKit



class DetailedParkDataView: UIView {
    var button: UIButton!
    var titleLable: UILabel!
    var nameLable: UILabel!
    var phoneNumberLable: UILabel!
    var imageView: UIImageView!
    
    
    @objc func removeDetailedView(_ sender: UIButton?) {
        if let bView = sender {
            let view = bView.superview
            view?.removeFromSuperview()
        }
    }

    
    func setParams(withType type: parkDataType, title: String, name: String = "", number: String = "000 111 2222") {
        self.imageView.image = imageForType(type)
        self.titleLable.text = title
        self.nameLable.text = name
        self.phoneNumberLable.text = number
        
        updateLablesForType(type)
    }
    
    
    func imageForType(_ type: parkDataType) -> UIImage? {
        return UIImage(named: type == .campSite ? "tent" : "camper" )
    }
    
    
    private func updateLablesForType(_ type: parkDataType) {
        if type == .campSite {
            self.phoneNumberLable.isHidden = true
        } else {
            self.phoneNumberLable.isHidden = false
        }
    }

    
    func createView(forType type: parkDataType) {
        
        button = UIButton(frame: .zero)
        
        button.backgroundColor = .blue
        self.addSubview(button)
        
        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -56).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        button.addTarget(self, action: #selector(removeDetailedView), for: .touchUpInside)
        
        let vb = self.bounds
        
        imageView = UIImageView(frame: CGRect(x: vb.width/2 - 40, y: 0, width: 80, height: 80))
       
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        imageView.image = imageForType(type)
       
    
        //add title
        titleLable = UILabel(frame: .zero)
         addSubview(titleLable)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        titleLable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLable.text = type == .campSite ? "Camp Site" : "Camping Guests"
        
        //add name lable
        nameLable = UILabel(frame: .zero)
         addSubview(nameLable)
        nameLable.textAlignment = .center
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        nameLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 20).isActive = true
        nameLable.text = "name"
        
        //phone # lable
        phoneNumberLable = UILabel(frame: .zero)
         addSubview(phoneNumberLable)
        phoneNumberLable.textAlignment = .center
        phoneNumberLable.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        phoneNumberLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        phoneNumberLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20).isActive = true
        phoneNumberLable.text = ""
        
        updateLablesForType(type)
        
    }
    
    convenience init(forType type: parkDataType, withFrame frame: CGRect) {
        self.init(frame: frame)
        
        self.createView(forType:type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
