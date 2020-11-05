import UIKit
import SkeletonView

class DetalleViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var lenguajeLabel: UILabel!
    @IBOutlet weak var generoLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionTextView: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var calificacionImage: UIImageView!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var degradadoView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: Propiedades
    public var idTvShow: Int!
    public var tvShow: Series!
    public var tvShowRes: TvShowRes!
    private var imdbID: URL?
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agregaGradiente()
        startSkeleton()
        
        if #available(iOS 13, *) {
            closeButton.isHidden = true
        }
        
        if idTvShow != nil {
            let tTvShowService = TvShowService()
            tTvShowService.consulta(id: idTvShow!) { (callback) in
                
                self.stopSkeleton()
                
                guard let urlString = callback.image?.original, let nombre = callback.name, let generos = callback.genres, let idioma = callback.language, let descripcion = callback.summary, let promedio = callback.rating?.average else {
                    return
                }
                
                guard let url = URL(string: urlString) else { return }
                guard let imgUrl = try? Data.init(contentsOf: url) else { return }
                
                var generosString = ""
                generos.forEach { i in
                    generosString += "\(i) "
                }
                
                if let imdb = callback.externals?.imdb {
                    self.imdbID = URL(string: "https://www.imdb.com/title/\(imdb)/")
                } else {
                    self.imdbButton.isHidden = true
                }
                
                self.likeImage.image = self.validaFavorito(id: self.idTvShow!) ? UIImage(named: "like2") : UIImage(named: "like1")
                self.coverImage.image = UIImage(data: imgUrl)
                self.nombreLabel.text = nombre
                self.generoLabel.text = generosString
                self.lenguajeLabel.text = idioma
                self.calificacionImage.image = UIImage(named: "\(Int(round(promedio * 0.5)))")
                self.descripcionTextView.text = descripcion.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</b>", with: "")
                
            }
        } else {
            self.stopSkeleton()
            guard let show = tvShow, let detalle = show.detalle, let imagen = detalle.imagen, let nombre = show.name, let genero = detalle.generos, let lenguaje = detalle.language, let descripcion = detalle.detalle  else {
                return
            }
            
            self.likeImage.image = UIImage(named: "like2")
            self.coverImage.image = UIImage(data: imagen)
            self.nombreLabel.text = nombre
            self.generoLabel.text = genero
            self.lenguajeLabel.text = lenguaje
            self.calificacionImage.image = UIImage(named: "\(Int(round(detalle.rating * 0.5)))")
            self.descripcionTextView.text = descripcion
            if let imdb = detalle.imdb {
                self.imdbID = imdb
            } else {
                self.imdbButton.isHidden = true
            }
        }
        
        tocarCorazon(view: likeImage)
    }
    
    //MARK: Actions
    @IBAction func imdbAction(_ sender: Any) {
        UIApplication.shared.open(self.imdbID!)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Eventos
    private func tocarCorazon(view: UIView) -> Void {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetalleViewController.corazonTocado(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func corazonTocado(sender: UITapGestureRecognizer) -> Void {
        if self.likeImage.image == UIImage(named: "like1") {
            self.likeImage.image = UIImage(named: "like2")
            self.alerta(valida: ShowsRepository.guardar(tvShow: tvShowRes), eliminar: false)
        } else {
            self.likeImage.image = UIImage(named: "like1")
            self.alerta(valida: ShowsRepository.eliminar(id: idTvShow != nil ? idTvShow : Int(tvShow.id)), eliminar: true)
        }
        
    }
    
    //MARK: Metodos
    private func validaFavorito(id: Int) -> Bool {
        guard let _ = ShowsRepository.consultar(id: id) as? Series else {
            return false
        }

        return true
    }
    
    private func alerta(valida: Bool, eliminar: Bool) -> Void {
        let titulo = valida ? ( eliminar ? "Eliminado" : "Guardado" ) : "Oops, algo salió mal!"
        let mensaje = valida ? ( eliminar ? "Se elimino de tus favoritos" : "Se agrego a favoritos" ) : "Hubo un problema al guardar/borrar este show de TV"
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alerta, animated: true, completion: nil)
    }
    
    private func agregaGradiente() -> Void {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        ]

        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        degradadoView.layer.addSublayer(layer0)
    }
    
    private func startSkeleton() -> Void {
        lenguajeLabel.showAnimatedGradientSkeleton()
        generoLabel.showAnimatedGradientSkeleton()
        nombreLabel.showAnimatedGradientSkeleton()
        descripcionTextView.showAnimatedGradientSkeleton()
        coverImage.showAnimatedGradientSkeleton()
        calificacionImage.showAnimatedGradientSkeleton()
    }
    
    private func stopSkeleton() -> Void {
        lenguajeLabel.hideSkeleton()
        generoLabel.hideSkeleton()
        nombreLabel.hideSkeleton()
        descripcionTextView.hideSkeleton()
        coverImage.hideSkeleton()
        calificacionImage.hideSkeleton()
    }
    
}
