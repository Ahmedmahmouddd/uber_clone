import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/presentation/home/bloc/drop_off_cubit/drop_off_cubit.dart';

class ToAddressContainer extends StatelessWidget {
  const ToAddressContainer({
    super.key,
    required this.darkTheme,
  });

  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: darkTheme ? DarkColors.accent : LightColors.accent),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: Colors.blue),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("To", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                BlocBuilder<DropOffLocationCubit, DropOffLocationState>(
                  builder: (context, state) {
                    return Text(
                      state is DropOffLocationUpdated
                          ? state.userDropOffLocation.locationName!
                          : "Choose Location",
                      style: TextStyle(
                          color: darkTheme ? DarkColors.textPrimary : LightColors.textSecondary,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
