import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../modal_class/reply_modal.dart';
import '../../../../utils/convert_utils.dart';


class ReplyWidget extends StatelessWidget {
  final ReplyModal replyModal;

  const ReplyWidget({
    required this.replyModal,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(replyModal.image!=''? replyModal.image! :
                  'https://dummyimage.com/600x400/000/fff&text=${replyModal.name![0].toUpperCase()}'),
                  fit: BoxFit.fill
              )
          ),
        ),
        SizedBox(width: 15.w,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(replyModal.name??'',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // SizedBox(width: 5.w,),
                  // Icon(Icons.circle,size: 8.r,),
                  SizedBox(width: 5.w,),

                  Text(ConvertUtils.getRelativeTime(replyModal.date!, replyModal.usaTimestamp!),
                    style: TextStyle(
                      color: Theme.of(context).brightness==Brightness.light?
                      Colors.black54 : Colors.white54,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 10.w,),
                ],
              ),
              SizedBox(height: 5.h,),
              Text(replyModal.text??'',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 15.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ],
    );
  }
}
