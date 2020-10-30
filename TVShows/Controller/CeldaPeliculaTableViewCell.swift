import UIKit
import SkeletonView

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
        self.startSkeleton()
        guard let urlString = tvShows.image?.medium, let nombre = tvShows.name, let idshow = tvShows.id else {
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        guard let imgUrl = try? Data.init(contentsOf: url) else { return }
        
        self.stopSkeleton()
        imagen.image = UIImage(data: imgUrl)
        titulo.text = nombre
        id = idshow
    }
    
    public func llenarDatosBase(tvShow: Series) -> Void {
        guard let imagenData = tvShow.image, let nombre = tvShow.name else {
            return
        }
        imagen.image = UIImage(data: imagenData)
        titulo.text = nombre
        id = Int(tvShow.id)
    }
    
    private func startSkeleton() -> Void {
        self.imagen.showAnimatedGradientSkeleton()
        self.titulo.showAnimatedGradientSkeleton()
    }
    
    private func stopSkeleton() -> Void {
        self.imagen.hideSkeleton()
        self.titulo.hideSkeleton()
    }
    
    //MARK: atributos
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
