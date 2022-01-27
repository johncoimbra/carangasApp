import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var car: Cars!
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            car = Cars()
        }
        
        car.name = tfName.text!
        car.brand = tfBrand.text!
        
        if (tfPrice.text?.isEmpty)!{
                    tfPrice.text="0.0"
                }

                if let preco = tfPrice.text {
                    car.price = Double(preco) ?? 0.0
                }
        car.gasType = scGasType.selectedSegmentIndex
        
        if car._id == nil {
            REST.save(car: self.car) { success in
                self.goBack()
            }
        }
        
        
    }
    
    // MARK: - Methods
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
                  
    

}
