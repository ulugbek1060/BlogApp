import 'package:blog_app/app_bloc.dart';
import 'package:blog_app/app_event.dart';
import 'package:blog_app/app_state.dart';
import 'package:blog_app/widgets/main_pop_up_button.dart';
import 'package:blog_app/widgets/storea_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class BlogScreen extends HookWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phote Gallery'),
        actions: [
          IconButton(
            onPressed: () {
              picker.pickImage(source: ImageSource.gallery).then(
                (img) {
                  if (img != null) {
                    context.read<AppBloc>().add(
                          AppEventUploadImage(
                            filePathToUpload: img.path,
                          ),
                        );
                  }
                },
              );
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton()
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: images
            .map(
              (img) => StorageImageWidget(
                image: img,
              ),
            )
            .toList(),
      ),
    );
  }
}
