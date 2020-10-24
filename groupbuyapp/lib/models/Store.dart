import 'PredefinedStores.dart';

class Store {
  final String storeWebsite;
  final String storeLogo;

  Store(
      this.storeWebsite,
      [this.storeLogo = '']
      );

  static Store getDummyData(PredefinedStores storeName) {
    switch(storeName) {
      case (PredefinedStores.AmazonSG):
        return new Store(
          "https://www.amazon.sg/",
          "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5d825aa26de3150009a4616c%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D0%26cropX2%3D416%26cropY1%3D0%26cropY2%3D416",
        )
        ;
      case (PredefinedStores.ezbuy):
        return new Store(
          "https://ezbuy.sg/",
            "https://3.bp.blogspot.com/-rqLWxK4GDto/WorLyTkHnCI/AAAAAAAAv-w/3scOPnaC4GM_n_3Z4JD1M2rHPBHKqULaQCLcBGAs/s1600/global-online-shopping-ezbuy-marketplace-beauty-products.jpg"
        );
      case (PredefinedStores.Shopee):
        return new Store(
            "https://shopee.sg/",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Shopee_logo.svg/1200px-Shopee_logo.svg.png"
        );
      case(PredefinedStores.Lazada):
        return new Store(
          "https://www.lazada.sg/",
            "https://miro.medium.com/max/940/1*oe5byyJt-nccptxIZKs8jA.png"
        );
      default:
        return new Store('');
    }

  }
}