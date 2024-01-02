import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'facerecognition_page.dart';
import 'faceregister_page.dart';
import 'refresh_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/facerecognition_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AttendanceController controller;
  late FaceRecognitionController faceRecognitionController;

  @override
  void initState() {
    super.initState();
    controller = AttendanceController();
    faceRecognitionController = FaceRecognitionController();
  }

  void checkFaceCode() async {
    try {
      List<FaceRecognitionData> faceRecognitionList = await faceRecognitionController.getFaceRecognition();

      bool faceCodeNotFound = faceRecognitionList.any((data) => data.kodeFace == "Face Code Not Found");
      bool faceCodeTwoRegistered = faceRecognitionList.length == 2;
      bool faceCodeOneRegistered = faceRecognitionList.length == 1;

      if (faceCodeNotFound) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("Not Registered"),
            message: AppLocalizations(globalLanguage).translate("You should register your face 3 times!"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else if (faceCodeOneRegistered) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("Register Again"),
            message: AppLocalizations(globalLanguage).translate("Register your face 2 more times!"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else if (faceCodeTwoRegistered) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("Register Again"),
            message: AppLocalizations(globalLanguage).translate("Register your face 1 more time!"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations(globalLanguage).translate("Attention!"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      AppLocalizations(globalLanguage).translate("1. Ensure that you are close to the Attendance Area / Finished Products Warehouse Area."),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      AppLocalizations(globalLanguage).translate("2. Make sure you are in a well-lit environment for effective face detection."),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      AppLocalizations(globalLanguage).translate("Cancel"),
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaceRecognitionPage(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations(globalLanguage).translate("Yes"),
                      style: const TextStyle(
                          color: AppColors.mainGreen,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 30, left: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations(globalLanguage).translate("welcome"),
                          style: TextStyle(
                            fontSize: 14,
                            color: globalTheme == 'Light Theme' ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          SessionManager().getNamaUser() ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold,
                            color: globalTheme == 'Light Theme' ? AppColors.deepGreen : AppColors.lightGreen
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset('assets/avatar.jpg', width: 50, height: 50),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    checkFaceCode();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.mainGreen,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                width: 40,
                                height: 40,
                                child: Image.asset('assets/facerecognition.png'),
                              ),
                              const Spacer(),
                              Text(
                                AppLocalizations(globalLanguage).translate("scanAttendance"),
                                style: const TextStyle(
                                    color: AppColors.mainGreen,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer()
                            ],
                          ),
                          const SizedBox(height: 10)
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<AttendanceData>>(
                  future: controller.futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const RefreshHomepage();
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/checkin.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations(globalLanguage).translate("checkIn"),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.getTodayIn(snapshot.data!), 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                  Text(
                                    controller.getTodayState(snapshot.data!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/checkout.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations(globalLanguage).translate("checkOut"),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.getTodayOut(snapshot.data!), 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                  Text(
                                    controller.getTodayState(snapshot.data!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations(globalLanguage).translate("attendance"), 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: globalTheme == 'Light Theme' ? Colors.black : Colors.white
                    )
                  ),
                  const Spacer(),
                  InkWell(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("seeAll"), 
                      style: TextStyle(
                        fontSize: 12, 
                        color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white, 
                        shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3)]
                      )
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RefreshAttendanceList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              FutureBuilder<List<AttendanceData>>(
                future: controller.futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('No data');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No data available');
                    }

                    int itemCount = snapshot.data!.length > 5 ? 5 : snapshot.data!.length;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            buildAttendanceCard(snapshot.data![index]),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildAttendanceCard(AttendanceData data) {
    bool hasTimeData = data.jamMasuk != null || data.jamPulang != null;
    

    Color cardColor = hasTimeData ? AppColors.mainGreen : const Color(0xFFBC5757);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Card(
          color: AppColors.grey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formatLanguageDate(data.tglAbsen)),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Image.asset("assets/checkin.png", width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(data.jamMasuk ?? 'N/A⠀'),
                    const Spacer(),
                    Image.asset("assets/checkout.png", width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(data.jamPulang ?? 'N/A⠀'),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatLanguageDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(dateTime);
    return formattedDate;
  }
}
