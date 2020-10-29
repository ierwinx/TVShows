import UIKit

class CeldaPeliculaTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    
    //MARK: Properties
    public var id: Int!
    
    //MARK: Ciclo de vida
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Metodos
    public func llenarInfo(tvShows: TvShowRes) -> Void {
        guard let urlString = tvShows.image?.medium, let nombre = tvShows.name, let idshow = tvShows.id else {
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        guard let imgUrl = try? Data.init(contentsOf: url) else { return }
        
        imagen.image = UIImage(data: imgUrl)
        titulo.text = nombre
        id = idshow
    }
    
    //MARK: atributos
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
