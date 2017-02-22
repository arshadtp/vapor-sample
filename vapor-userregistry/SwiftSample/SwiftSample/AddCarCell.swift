//
//  AddCarCell.swift
//  SwiftSample
//
//  Created by qbuser on 15/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddCarCell: UITableViewCell, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    typealias CompletionHandler = (_ success:String?) -> Void

    var didAddCar: CompletionHandler? = nil
    
    @IBOutlet weak var makeField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    weak var parentVc: HomeViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doneButtonAction(_ sender: Any) {
    
        let image = self.imageButton.image(for: .normal) ?? nil
        let make: String? = self.makeField.text
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        BaseService.requestMultiPartURL(root+addCar, image: image, params: ["make":make as AnyObject, "model":self.modelField.text as AnyObject], headers: ["accessToken": UserDefaults.standard.value(forKey: accessToken) as! String], success: { (JSON) in
        
            self.makeField.text = nil
            self.modelField.text = nil
            self.imageButton.setImage(nil, for: .normal)
            self.didAddCar!(nil)
        }) { (Error) in
            self.didAddCar!(Error.localizedDescription)
//            UIAlertController.init(title: "Error", message: Error.localizedDescription, preferredStyle: .alert) .show((self.parentVc?.navigationController!)!, sender: self)

         print(Error)
        }
    }
    
    @IBAction func imagePickerAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            parentVc?.present(imag, animated: true, completion: nil)
        }
 
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageButton .setImage(pickedImage, for: .normal)
        }
        parentVc?.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
    }
   
}
