import 'dart:ui';

import 'package:flutter/material.dart';

class LikesVeiws extends StatelessWidget {
  final int likes;
  final int veiws;
  const LikesVeiws({super.key, required this.likes, required this.veiws});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: ColoredBox(
              color: const Color.fromARGB(100, 242, 242, 242),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.5),
                      child: Icon(
                        Icons.thumb_up_alt_outlined,
                      ),
                    ),
                    Text(likes.toString(),
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(width: 20),
                    const Padding(
                      padding: EdgeInsets.all(2.5),
                      child: Icon(
                        Icons.visibility_outlined,
                      ),
                    ),
                    Text(veiws.toString(),
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
