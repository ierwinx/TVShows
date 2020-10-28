import UIKit

class CeldaPeliculaTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    
    //MARK: Properties
    private var id: Int!
    
    //MARK: Ciclo de vida
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Metodos
    public func llenarInfo() -> Void {
        
    }
    
    //MARK: atributos
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
