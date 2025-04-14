import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/cartitem.dart';
import 'package:flutterprjgroup1/product.dart';
import 'package:flutterprjgroup1/productcard.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    products = allProducts();
  }

  void addToCart(Product product) {
    setState(() {
      final existingItem = cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product, 0),
      );

      if (existingItem.quantity > 0) {
        existingItem.quantity++;
      } else {
        cartItems.add(CartItem(product, 1));
      }
    });
  }

  void increaseQuantity(Product product) {
    setState(() {
      final item = cartItems.firstWhere(
        (item) => item.product.id == product.id,
      );
      item.quantity++;
    });
  }

  void decreaseQuantity(Product product) {
    setState(() {
      final item = cartItems.firstWhere(
        (item) => item.product.id == product.id,
      );
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        cartItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('images/logo.png', height: 30),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isInCart = cartItems.any(
            (item) => item.product.id == product.id,
          );
          final quantity =
              isInCart
                  ? cartItems
                      .firstWhere((item) => item.product.id == product.id)
                      .quantity
                  : 0;

          return ProductCard(
            product,
            () => addToCart(product), // callback for adding prodict
            () => increaseQuantity(product), // callback for increase quantity
            () => decreaseQuantity(product), // callback for decreasing
            isInCart,
            quantity,
          );
        },
      ),
    );
  }

  List<Product> allProducts() {
    return [
      Product(
        1,
        "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        109.95,
        "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday essentials in the main compartment, and carry your gear with ease. The Fjallraven Foldsack No. 1 offers both style and practicality, making it an ideal companion for both outdoor adventures and urban commuting. Made from durable, weather-resistant material, this backpack keeps your belongings safe and organized, no matter where life takes you.",
        "men's clothing",
        ["images/1.1.jpg", "images/1.2.jpg", "images/1.3.jpg"],
        "Fjallraven",
        "90 day return",
        "Size: 15L capacity, Dimensions: 40 x 30 x 15 cm, Material: G-1000 HeavyDuty Eco, Color: Dark Olive",
        Rating(3.9, 120),
      ),
      Product(
        2,
        "Mens Casual Premium Slim Fit T-Shirts",
        22.3,
        "This slim-fitting casual T-shirt features a contrast raglan long sleeve design and a three-button Henley placket. Crafted from lightweight, breathable fabric, it ensures comfort for all-day wear, making it perfect for casual outings or relaxed weekends. The shirt is designed to provide a sleek, modern look with solid stitching for durability. Its versatility makes it an essential addition to any wardrobe, whether you're a baseball fan or just enjoy stylish casual wear.",
        "men's clothing",
        ["images/2.1.jpg", "images/2.2.jpg", "images/2.3.jpg"],
        "Casual Wear Co.",
        "30 day return",
        "Material: 100% Cotton, Sizes: S, M, L, XL, Colors: Black, White, Navy",
        Rating(4.1, 259),
      ),
      Product(
        3,
        "Mens Cotton Jacket",
        55.99,
        "This versatile jacket is perfect for transitioning between seasons. Designed for warmth and comfort, it features a sturdy cotton exterior and a soft, insulated lining. Ideal for spring, autumn, and winter, it keeps you cozy during outdoor activities such as hiking, camping, or casual strolls. Whether you're heading to work or spending time with family, this jacket combines style with functionality, offering a practical solution for any occasion. It also makes for an excellent gift for loved ones.",
        "men's clothing",
        [
          "images/3.1.jpg",
          "images/3.2.jpg",
          "images/3.3.jpg",
          "images/3.4.jpg",
        ],
        "Outdoor Apparel Co.",
        "90 day return",
        "Material: 100% Cotton (Outer), 100% Polyester (Lining), Available Sizes: M, L, XL, Color: Olive Green",
        Rating(4.7, 500),
      ),
      Product(
        4,
        "Mens Casual Slim Fit",
        15.99,
        "These slim-fit pants offer a sleek, modern silhouette with a comfortable stretch fabric for all-day wear. Ideal for both casual and semi-formal occasions, they are available in various colors to match different styles. Please note that color may appear slightly different depending on your screen settings, and sizes may vary based on body type. Refer to the detailed size chart for the perfect fit.",
        "men's clothing",
        ["images/4.1.jpg", "images/4.2.jpg"],
        "SlimFit Apparel",
        "not returnable",
        "Material: 97% Cotton, 3% Spandex, Available Sizes: 28, 30, 32, 34, Color: Black, Navy, Charcoal",
        Rating(2.1, 430),
      ),
      Product(
        5,
        "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
        695,
        "Inspired by the mythical Naga, a water dragon that symbolizes protection and love, this stunning bracelet is crafted from a combination of gold and silver, featuring a dragon station. Wear this piece to signify abundance and love, or with the dragon facing outward for protection. Part of the Legends Collection, it’s designed for those who seek balance and harmony. Its intricate design and luxurious finish make it a perfect statement piece or a thoughtful gift.",
        "jewelery",
        ["images/5.1.jpg", "images/5.2.jpg"],
        "John Hardy",
        "30 day return",
        "Material: 925 Sterling Silver, 18K Gold, Length: Adjustable 7-8 inches",
        Rating(4.6, 400),
      ),
      Product(
        6,
        "Solid Gold Petite Micropave",
        168,
        "This delicate micropave ring is made with 14K solid gold and features tiny diamonds arranged in a stunning micropave design. Perfect for layering or wearing solo, it adds a subtle touch of elegance to any look. Whether you're celebrating an anniversary, engagement, or simply want to treat yourself, this ring offers timeless beauty and sophistication. It is an ideal piece for those who love dainty and refined jewelry.",
        "jewelery",
        ["images/6.1.jpg", "images/6.2.jpg"],
        "Hafeez Center",
        "30 day return",
        "Material: 14K Solid Gold, Diamonds, Available Sizes: 6, 7, 8",
        Rating(3.9, 70),
      ),
      Product(
        7,
        "White Gold Plated Princess",
        9.99,
        "This classic princess cut solitaire ring is a timeless symbol of love and commitment. Made from white gold-plated material, it makes a stunning gift for engagements, weddings, or any romantic occasion. Whether you’re popping the question or celebrating an anniversary, this ring is designed to stand the test of time. Its elegant design and affordable price make it a perfect choice for those seeking a simple, yet sophisticated piece of jewelry.",
        "jewelery",
        ["images/7.1.jpg", "images/7.2.jpg", "images/7.3.jpg"],
        "Diamond Creations",
        "30 day return",
        "Material: White Gold Plated, Stone: Cubic Zirconia, Size: 6, 7, 8",
        Rating(3, 400),
      ),
      Product(
        8,
        "Pierced Owl Rose Gold Plated Stainless Steel Double",
        10.99,
        "Rose Gold Plated Double Flared Tunnel Plug Earrings. Made of 316L Stainless Steel. These earrings are a perfect blend of style and durability, designed for long-lasting wear. The rose gold plating gives it a sleek, modern appearance while the stainless steel ensures resistance to rust and corrosion. Ideal for adding a touch of elegance to any outfit, these earrings are both fashionable and comfortable.",
        "jewelery",
        ["images/8.1.jpg", "images/8.2.jpg", "images/8.3.jpg"],
        "Pierced Owl",
        "30 day return",
        "Material: 316L Stainless Steel, Color: Rose Gold, Size: Double Flared, Style: Tunnel Plug",
        Rating(1.9, 100),
      ),
      Product(
        9,
        "Samsung 2TB Elements Portable External Hard Drive - USB 3.0",
        64,
        "USB 3.0 and USB 2.0 Compatibility. Fast data transfers. Improve PC performance with high capacity storage. The Samsung 2TB Elements portable external hard drive is designed for users who need reliable, high-speed data storage. With compatibility across a range of operating systems, this drive is perfect for transferring large files and backing up important data. Its portable nature makes it ideal for on-the-go storage and access to your files anywhere.",
        "electronics",
        ["images/9.1.jpg", "images/9.2.jpg", "images/9.3.jpg"],
        "Samsung",
        "90 day return",
        "Capacity: 2TB, Interface: USB 3.0, USB 2.0, Compatibility: Windows 10, 8.1, 7, Reformatting required for Mac, Color: Black",
        Rating(3.3, 203),
      ),
      Product(
        10,
        "SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s",
        109,
        "The SanDisk SSD PLUS 1TB Internal SSD provides fast and efficient storage with read/write speeds of up to 535MB/s and 450MB/s, respectively. Ideal for upgrading your PC's boot-up time, load applications faster, and enhancing overall performance. This SSD features the perfect balance of performance and reliability, making it an excellent choice for users looking to boost their system’s speed and efficiency. With a reliable and durable design, it’s the perfect storage solution for both everyday computing and more demanding applications.",
        "electronics",
        ["images/10.1.jpg", "images/10.2.jpg", "images/10.3.jpg"],
        "SanDisk",
        "30 day return",
        "Capacity: 1TB, Interface: SATA III 6 Gb/s, Read Speed: 535MB/s, Write Speed: 450MB/s, Color: Black",
        Rating(2.9, 470),
      ),
      Product(
        11,
        "Ambrane 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5",
        109,
        "Ambrane 256GB SSD utilizes advanced 3D NAND flash technology to deliver impressive transfer speeds and improved overall system performance. The inclusion of SLC Cache Technology helps to boost performance and increase the lifespan of the SSD. Its slim 7mm design makes it ideal for ultrabooks and ultra-slim notebooks. The Ambrane A55 SSD supports advanced features such as TRIM, Garbage Collection, RAID, and ECC to ensure reliable and optimized performance for demanding workloads.",
        "electronics",
        ["images/11.1.jpg", "images/11.2.jpg"],
        "Ambrane",
        "30 day return",
        "Capacity: 256GB, Interface: SATA III 6 Gb/s, Form Factor: 2.5 inches, Color: Black, Design: 7mm slim",
        Rating(4.8, 319),
      ),
      Product(
        12,
        "PlayStation 5 Console",
        114,
        "Experience lightning-fast loading with the PS5's ultra-high-speed SSD. Immerse yourself in breathtaking visuals with ray tracing and 4K gaming. The PlayStation 5 Console is designed for gamers who demand the highest level of performance, featuring stunning 4K resolution and ray tracing technology for lifelike graphics. The DualSense wireless controller adds another layer to the experience with adaptive triggers and haptic feedback, offering a more immersive and tactile gaming experience. Its sleek design, paired with cutting-edge technology, delivers a gaming experience like no other.",
        "electronics",
        ["images/12.1.jpg", "images/12.2.jpg", "images/12.3.jpg"],
        "Sony",
        "90 day return",
        "Storage: Ultra-high-speed SSD, Graphics: Ray tracing, 4K gaming, Controller: DualSense wireless, Design: Sleek, modern",
        Rating(4.8, 40000),
      ),
      Product(
        13,
        "Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin",
        599,
        "The Acer SB220Q bi 21.5 inches Full HD IPS monitor offers stunning visuals with its wide viewing angles and vibrant colors. Its ultra-thin design allows it to blend seamlessly into any workspace while delivering a smooth and responsive experience with a 75Hz refresh rate. The monitor supports Radeon FreeSync technology to reduce screen tearing and stuttering. Its 4ms response time makes it perfect for gaming and other fast-paced applications, while its 178-degree horizontal and vertical viewing angles ensure excellent visibility from multiple angles.",
        "electronics",
        ["images/13.1.jpg", "images/13.2.jpg"],
        "Acer",
        "30 day return",
        "Screen Size: 21.5 inches, Resolution: 1920 x 1080 Full HD, Panel Type: IPS, Refresh 75Hz, Color: Black, Response Time: 4ms",
        Rating(2.9, 250),
      ),
      Product(
        14,
        "Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor (LC49HG90DMNXZA) – Super Ultrawide Screen QLED",
        999.99,
        "The Samsung 49-Inch CHG90 Curved Gaming Monitor offers a stunning super ultrawide 32:9 aspect ratio, equivalent to two 27-inch screens side by side. Equipped with Quantum Dot (QLED) technology and HDR support, it delivers exceptional color accuracy and contrast for an immersive gaming experience. With a 144Hz refresh rate and 1ms ultra-fast response time, motion blur and ghosting are minimized, ensuring smooth and responsive gameplay. Perfect for both professional gamers and content creators, this monitor provides a wide screen area for multitasking and enhanced productivity.",
        "electronics",
        ["images/14.1.jpg", "images/14.2.jpg", "images/14.3.jpg"],
        "Samsung",
        "30 day return",
        "Size: 49 inches, Color: Black, Material: Plastic and Metal, Dimensions: 47.1 x 18.7 x 10.3 inches",
        Rating(2.2, 140),
      ),
      Product(
        15,
        "BIYLACLESEN Women's 3-in-1 Snowboard Jacket Winter Coats",
        56.99,
        "The BIYLACLESEN 3-in-1 Snowboard Jacket offers exceptional versatility for all weather conditions. Designed with a detachable liner, this jacket can be worn as a full winter coat, or the inner fleece liner can be removed for lighter layers. It’s made from 100% polyester for durability, with a warm fleece lining that keeps you comfortable in cold temperatures. The jacket features a stand collar, zippered pockets for storage, and an adjustable and detachable hood. Perfect for outdoor sports or casual wear, it is designed to withstand snow, wind, and rain.",
        "women's clothing",
        ["images/15.1.jpg", "images/15.2.jpg", "images/15.3.jpg"],
        "BIYLACLESEN",
        "90 day return",
        "Material: 100% Polyester, Color: Blue, Size: S, M, L, XL, Dimensions: 18 x 14 x 5 inches",
        Rating(2.6, 235),
      ),
      Product(
        16,
        "Lock and Love Men's Removable Hooded Faux Leather Moto Biker Jacket",
        29.95,
        "The Lock and Love Men's Faux Leather Moto Jacket combines edgy biker style with the comfort of a removable hood. Made with high-quality polyurethane and polyester materials, the jacket features a classic button detail on the waist, stylish stitching at the sides, and two front pockets for convenience. The hood can be detached for a more streamlined look, and the jacket is designed for easy care with hand wash instructions. This jacket is a great addition to any casual wardrobe, perfect for those who want to stand out in style without compromising on comfort.",
        "men's clothing",
        ["images/16.1.jpg", "images/16.2.jpg", "images/16.3.jpg"],
        "Lock and Love",
        "Not returnable",
        "Material: Polyurethane (shell), Polyester (lining), Polyester and Cotton (sweater), Color: Black, Size: M, L, XL, Dimensions: 24 x 20 x 6 inches",
        Rating(2.9, 340),
      ),
      Product(
        17,
        "Denim Jacket Windbreaker Striped Climbing",
        39.99,
        "The Denim Jacket Windbreaker Striped Climbing is the perfect blend of fashion and function. Its lightweight fabric makes it ideal for both casual wear and outdoor activities. The jacket features a hood with adjustable drawstrings, long sleeves, and a button and zipper front closure for easy wear. It has a striped lining and two side pockets that are spacious enough for everyday essentials. The generous hood ensures you stay comfortable in light rain or wind, and the design adds a trendy touch to your wardrobe.",
        "women's clothing",
        ["images/17.1.jpg", "images/17.2.jpg", "images/17.3.jpg"],
        "Windbreaker",
        "30 day return",
        "Material: Denim, Cotton Lining, Color: Blue, Size: S, M, L, XL, Dimensions: 22 x 18 x 4 inches",
        Rating(3.8, 679),
      ),
      Product(
        18,
        "MBJ Women's Solid Short Sleeve Boat Neck V",
        9.85,
        "The MBJ Women's Solid Short Sleeve Boat Neck V-neck Tee offers both comfort and style. Made from a blend of rayon and spandex, this lightweight top has a great stretch to ensure a comfortable fit. The boat neck design gives it a sophisticated look, while the short sleeves make it perfect for warm weather. The bottom hem is double-stitched for durability, and the fabric is soft to the touch, making it ideal for everyday wear. It’s a versatile piece that pairs well with jeans, skirts, or shorts for any casual occasion.",
        "women's clothing",
        ["images/18.1.jpg", "images/18.2.jpg"],
        "MBJ",
        "30 day return",
        "Material: 95% Rayon, 5% Spandex, Color: Solid colors, Size: S, M, L, XL, Dimensions: 14 x 10 x 0.5 inches",
        Rating(4.7, 130),
      ),
      Product(
        19,
        "Opna Women's Short Sleeve Moisture",
        7.95,
        "The Opna Women's Short Sleeve Moisture-Wicking Tee is made of 100% cationic polyester, offering both comfort and breathability. Designed for active wear, this shirt features moisture-wicking technology that keeps you dry and comfortable throughout the day. The V-neck collar provides a flattering fit, while the lightweight and roomy design ensures ease of movement. This tee is pre-shrunk for a great fit and is perfect for workouts, casual wear, or layering with other clothing for different looks.",
        "women's clothing",
        ["images/19.1.jpg", "images/19.2.jpg"],
        "Opna",
        "30 day return",
        "Material: 100% Polyester, Color: Variety of colors, Size: S, M, L, XL, Dimensions: 12 x 8 x 0.5 inches",
        Rating(4.5, 146),
      ),
      Product(
        20,
        "DANVOUY Womens T Shirt Casual Cotton Short",
        12.99,
        "This DANVOUY Women's T-Shirt is made of 95% cotton and 5% spandex, offering a comfortable, soft feel with just the right amount of stretch. Designed with a V-neck and short sleeves, it features a stylish letter print that adds a trendy touch to your casual wardrobe. The fabric is breathable and ideal for year-round wear, making it suitable for a variety of occasions such as casual outings, office wear, or even beach days. Whether you're heading to school, running errands, or relaxing at home, this shirt provides versatility and comfort for all seasons including Spring, Summer, Autumn, and Winter.",
        "women's clothing",
        ["images/20.1.jpg", "images/20.2.jpg"],
        "DANVOUY Apparel",
        "90 day return",
        "Size: S, M, L, XL, Color: White, Black, Grey, Navy, Material: 95% Cotton, 5% Spandex, Dimensions: Length: 26 inches, Chest: 18 inches",
        Rating(3.6, 145),
      ),
    ];
  }
}
