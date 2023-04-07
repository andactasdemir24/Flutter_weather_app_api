class ImageModel {
  final String imageUrl;

  ImageModel({required this.imageUrl});

  static List<ImageModel> images = [
    ImageModel(
      imageUrl: 'assets/lottie/night.json',
    )
  ];
}
