//
//  CarTableViewCell.swift
//  SwiftSample
//
//  Created by qbuser on 16/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import AlamofireImage

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCarDetails(detal: Car)  {
        makeLabel.text = "Make:  " + detal.make
        modelLabel.text = "Model:  " + detal.model
        self.carImage.image = #imageLiteral(resourceName: "Paceholder")
        if detal.imageUrl?.lengthOfBytes(using: String.Encoding.utf8) != 0 {
                let urlString = root+"/user/image/"+detal.imageUrl!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let url = URL.init(string: urlString)!
                loadImageWithURL(url: url)
            }
    }
    
    func loadImageWithURL(url: URL) {
        
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(UserDefaults.standard.value(forKey: accessToken) as! String, forHTTPHeaderField: "accessToken")
        self.carImage?.af_setImage(withURLRequest: urlRequest, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: { (image) in
            DispatchQueue.main.async {
                if let data = image.data
                {
                    let imageDownloaded = UIImage(data:data,scale:1.0)
                    self.carImage.image = imageDownloaded//UIImage.init(named: "asa")
                    
                }
            }
        })
        
    }

}

