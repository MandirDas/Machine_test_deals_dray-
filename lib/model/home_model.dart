class Home {
  Home({
    required this.status,
    required this.data,
  });

  final int? status;
  final Data? data;

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.bannerOne,
    required this.category,
    required this.products,
    required this.bannerTwo,
    required this.newArrivals,
    required this.bannerThree,
    required this.categoriesListing,
    required this.topBrands,
    required this.brandListing,
    required this.topSellingProducts,
    required this.featuredLaptop,
    required this.upcomingLaptops,
    required this.unboxedDeals,
    required this.myBrowsingHistory,
  });

  final List<Banner> bannerOne;
  final List<Category> category;
  final List<Product> products;
  final List<Banner> bannerTwo;
  final List<BrandListing> newArrivals;
  final List<Banner> bannerThree;
  final List<BrandListing> categoriesListing;
  final List<TopBrand> topBrands;
  final List<BrandListing> brandListing;
  final List<Category> topSellingProducts;
  final List<BrandListing> featuredLaptop;
  final List<TopBrand> upcomingLaptops;
  final List<BrandListing> unboxedDeals;
  final List<BrandListing> myBrowsingHistory;

  factory Data.fromJson(Map<String, dynamic> json) {
    print(json);
    return Data(
      bannerOne: json["banner_one"] == null
          ? []
          : List<Banner>.from(
              json["banner_one"]!.map((x) => Banner.fromJson(x))),
      category: json["category"] == null
          ? []
          : List<Category>.from(
              json["category"]!.map((x) => Category.fromJson(x))),
      products: json["products"] == null
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x))),
      bannerTwo: json["banner_two"] == null
          ? []
          : List<Banner>.from(
              json["banner_two"]!.map((x) => Banner.fromJson(x))),
      newArrivals: json["new_arrivals"] == null
          ? []
          : List<BrandListing>.from(
              json["new_arrivals"]!.map((x) => BrandListing.fromJson(x))),
      bannerThree: json["banner_three"] == null
          ? []
          : List<Banner>.from(
              json["banner_three"]!.map((x) => Banner.fromJson(x))),
      categoriesListing: json["categories_listing"] == null
          ? []
          : List<BrandListing>.from(
              json["categories_listing"]!.map((x) => BrandListing.fromJson(x))),
      topBrands: json["top_brands"] == null
          ? []
          : List<TopBrand>.from(
              json["top_brands"]!.map((x) => TopBrand.fromJson(x))),
      brandListing: json["brand_listing"] == null
          ? []
          : List<BrandListing>.from(
              json["brand_listing"]!.map((x) => BrandListing.fromJson(x))),
      topSellingProducts: json["top_selling_products"] == null
          ? []
          : List<Category>.from(
              json["top_selling_products"]!.map((x) => Category.fromJson(x))),
      featuredLaptop: json["featured_laptop"] == null
          ? []
          : List<BrandListing>.from(
              json["featured_laptop"]!.map((x) => BrandListing.fromJson(x))),
      upcomingLaptops: json["upcoming_laptops"] == null
          ? []
          : List<TopBrand>.from(
              json["upcoming_laptops"]!.map((x) => TopBrand.fromJson(x))),
      unboxedDeals: json["unboxed_deals"] == null
          ? []
          : List<BrandListing>.from(
              json["unboxed_deals"]!.map((x) => BrandListing.fromJson(x))),
      myBrowsingHistory: json["my_browsing_history"] == null
          ? []
          : List<BrandListing>.from(json["my_browsing_history"]!
              .map((x) => BrandListing.fromJson(x))),
    );
  }
}

class Banner {
  Banner({
    required this.banner,
  });

  final String? banner;

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      banner: json["banner"],
    );
  }
}

class BrandListing {
  BrandListing({
    required this.icon,
    required this.offer,
    required this.brandIcon,
    required this.label,
    required this.price,
  });

  final String? icon;
  final String? offer;
  final String? brandIcon;
  final String? label;
  final String? price;

  factory BrandListing.fromJson(Map<String, dynamic> json) {
    return BrandListing(
      icon: json["icon"],
      offer: json["offer"],
      brandIcon: json["brandIcon"],
      label: json["label"],
      price: json["price"],
    );
  }
}

class Category {
  Category({
    required this.label,
    required this.icon,
  });

  final String? label;
  final String? icon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      label: json["label"],
      icon: json["icon"],
    );
  }
}

class Product {
  Product({
    required this.icon,
    required this.offer,
    required this.label,
    required this.subLabel,
    required this.sublabel,
  });

  final String? icon;
  final String? offer;
  final String? label;
  final String? subLabel;
  final String? sublabel;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json["icon"],
      offer: json["offer"],
      label: json["label"],
      subLabel: json["SubLabel"],
      sublabel: json["Sublabel"],
    );
  }
}

class TopBrand {
  TopBrand({
    required this.icon,
  });

  final String? icon;

  factory TopBrand.fromJson(Map<String, dynamic> json) {
    return TopBrand(
      icon: json["icon"],
    );
  }
}
