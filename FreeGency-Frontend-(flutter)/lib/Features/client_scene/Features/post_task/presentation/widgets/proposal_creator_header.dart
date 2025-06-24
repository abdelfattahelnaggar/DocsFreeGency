import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ProposalCreatorHeader extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  const ProposalCreatorHeader({super.key, this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: imageUrl ??
                  'https://tse2.mm.bing.net/th?id=OIP.PZsMLTIgXaEsdCA0VjTo7gHaLH&rs=1&pid=ImgDetMain',
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        16.width,
        ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: name ?? "No Name",
        ),
      ],
    );
  }
}
