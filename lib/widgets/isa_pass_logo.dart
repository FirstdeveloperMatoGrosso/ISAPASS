import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class IsaPassLogo extends StatelessWidget {
  final double size;

  const IsaPassLogo({
    super.key,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone do ticket
          SizedBox(
            height: size * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.confirmation_number,
                  size: size * 0.5,
                  color: AppTheme.primaryColor,
                ),
                Positioned(
                  top: size * 0.19,
                  child: Container(
                    width: size * 0.15,
                    height: size * 0.15,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      size: size * 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size * 0.05),
          // Texto IsaPass
          Text(
            'IsaPass',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
