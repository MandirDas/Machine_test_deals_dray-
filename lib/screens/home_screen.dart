import 'package:flutter/material.dart';
import '../model/home_model.dart' as homeModel;
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<homeModel.Home> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = ApiService.getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<homeModel.Home>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.data == null) {
            return Center(child: Text('No data available'));
          }

          final homeData = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: BannerCarousel(banners: homeData.data!.bannerOne),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'KYC Pending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'You need to provide the required \ndocuments for your account activation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Click Here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CategoryGrid(categories: homeData.data!.category),
                UnboxedDeals(deals: homeData.data!.unboxedDeals),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UnboxedDeals extends StatelessWidget {
  final List<homeModel.BrandListing> deals;

  const UnboxedDeals({Key? key, required this.deals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      color: Colors.teal.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Unboxed Deals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deals.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 230,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(80, 20, 80, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  child: Image.network(
                                    deals[index].icon ??
                                        'https://via.placeholder.com/160x160',
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(height: 70),
                                  Text(
                                    'From ₹${deals[index].price ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // SizedBox(height: 4),
                                  Text(
                                    deals[index].label ?? 'Unknown Phone',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 170,
                      child: Container(
                        height: 25,
                        width: 62,
                        // alignment: Alignment(0, 0.5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${deals[index].offer ?? 'un'} off',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BannerCarousel extends StatelessWidget {
  final List<homeModel.Banner> banners;

  const BannerCarousel({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: banners[index].banner != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        banners[index].banner!,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final List<homeModel.Category> categories;

  const CategoryGrid({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (categories[index].icon != null)
              Image.network(categories[index].icon!, height: 50),
            Text(categories[index].label ?? 'Unknown'),
          ],
        );
      },
    );
  }
}

class ProductList extends StatelessWidget {
  final List<homeModel.Product> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                if (products[index].icon != null)
                  Image.network(products[index].icon!, height: 100),
                Text(products[index].label ?? 'Unknown'),
                Text(products[index].offer ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }
}
