part of 'helpers.dart';

class ImagePickerHelper {
  static Future<void> pickImage(
    BuildContext context,
    Function(File?) onImagePicked, {
    required ImageSource source,
  }) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      // 📌 انسخ الصورة لمسار دائم
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File newImage = await File(pickedFile.path).copy(newPath);

      onImagePicked(newImage);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  static void showImagePicker(
      BuildContext context, Function(File?) onImagePicked) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LocalizedLabel(
                text: "choose_image",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: LocalizedLabel(
                  text: "choose_image",
                  style: TextStyle(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
                onTap: () => pickImage(context, onImagePicked,
                    source: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: LocalizedLabel(
                  text: "choose_from_gallery",
                  style: TextStyle(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
                onTap: () => pickImage(context, onImagePicked,
                    source: ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }
}
