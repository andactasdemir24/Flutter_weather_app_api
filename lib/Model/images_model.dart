class ImageModel {
  final String imageUrl;

  ImageModel({required this.imageUrl});

  static List<ImageModel> images = [
    ImageModel(
      imageUrl: 'assets/lottie/sunny.json',
    ),
    ImageModel(
      imageUrl: 'assets/lottie/rainy.json',
    ),
    ImageModel(
      imageUrl: 'assets/lottie/snow.json',
    ),
    ImageModel(
      imageUrl: 'assets/lottie/night.json',
    )
  ];
}
