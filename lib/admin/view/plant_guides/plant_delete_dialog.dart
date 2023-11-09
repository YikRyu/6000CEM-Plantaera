import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/admin/view_model/admin_plant_viewmodel.dart';
import 'package:plantaera/res/colors.dart';

class PlantDeleteDialog extends StatelessWidget {
  PlantDeleteDialog({super.key,required this.currentPlantId ,required this.coverURL, required this.galleryList});

  final AdminPlantVM plantVM = AdminPlantVM();
  String currentPlantId;
  String coverURL;
  List<String> galleryList;

  deletePlantGuide(String currentPlantId, String coverURL, List<String> galleryList, BuildContext context) async{
    String deleteStatus = await plantVM.deletePlantGuide(currentPlantId, coverURL, galleryList);

    if(deleteStatus == 'ok'){
      Fluttertoast.showToast(
        msg: "Plant guide deleted. Redirecting back to previous page....",
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
                "Are you sure you want to delete this plant guide?",
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
                          onPressed: () { deletePlantGuide(currentPlantId, coverURL, galleryList, context); },
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
