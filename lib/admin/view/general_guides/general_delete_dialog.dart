import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/admin/view_model/admin_generalGuide_viewmodel.dart';
import 'package:plantaera/res/colors.dart';

class GeneralDeleteDialog extends StatelessWidget {
  GeneralDeleteDialog({super.key,required this.currentGuideId, required this.bannerURL});

  final AdminGeneralGuideVM guideVM = AdminGeneralGuideVM();
  String currentGuideId;
  String bannerURL;

  deleteGeneralGuide(String currentGuideId, String bannerURL, BuildContext context) async{
    String deleteStatus = await guideVM.deleteGeneralGuide(currentGuideId, bannerURL);

    if(deleteStatus == 'ok'){
      Fluttertoast.showToast(
        msg: "Guide article deleted. Redirecting back to previous page....",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Are you sure you want to delete this guide article?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 165,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () { deleteGeneralGuide(currentGuideId, bannerURL, context); },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cherry,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.9),
                          ),
                          child: Center(
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ), //logout button
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {Navigator.pop(context);},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cherry,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.9),
                          ),
                          child: Center(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ), //logout button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
