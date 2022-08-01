import 'dart:io';

import 'package:domain/model/message_attachment/message_attachment_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/extensions/build_context.dart';

class PhotoMessageAttachment extends StatelessWidget {
  const PhotoMessageAttachment(
    this.photos, {
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final List<MessageAttachmentPhoto> photos;
  final double maxWidth;

  static const layoutVariants = {
    1: [1],
    2: [2],
    3: [1, 2],
    4: [1, 3],
    5: [2, 3],
    6: [3, 3],
    7: [1, 3, 3],
    8: [2, 3, 3],
    9: [2, 3, 4],
    10: [3, 3, 4],
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [];

    var layout = layoutVariants[photos.length]!;

    int rowIndex = 0;
    List<Widget> rows = [];
    double? prevPhotoHeight;
    for (var photo in photos) {
      var maxPhotos = layout[rowIndex];

      var haveNextPhoto = rows.length + 1 < maxPhotos;
      var haveNextRow = rowIndex + 1 < layout.length;

      var photoWidth = ((maxWidth - 2) - maxPhotos * 2) / maxPhotos;
      prevPhotoHeight ??= photo.height / (photo.width / photoWidth);

      if (prevPhotoHeight > maxWidth) prevPhotoHeight = maxWidth;

      rows.add(Padding(
        padding: EdgeInsets.only(
          right: haveNextPhoto ? 2 : 0,
          bottom: haveNextRow ? 2 : 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: photo.filePath != null
              ? Image.file(
                  File(photo.filePath!),
                  width: photoWidth,
                  height: prevPhotoHeight,
                  fit: BoxFit.cover,
                )
              : SizedBox(
                  width: photoWidth,
                  height: prevPhotoHeight,
                  child: ColoredBox(
                    color: context.theme.scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyLight.delete,
                          color: context.extraColors.secondaryIconColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.loc.file_deleted,
                          style: context.textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ));

      if (rows.length >= maxPhotos) {
        columns.add(Row(children: rows));
        rows = [];
        prevPhotoHeight = null;

        rowIndex++;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 2, right: 2, bottom: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: columns),
      ),
    );
  }
}
