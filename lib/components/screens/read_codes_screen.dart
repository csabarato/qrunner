import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrunner/components/buttons/rounded_button.dart';
import 'package:qrunner/components/screens/qr_code_reader_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/result_model.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:qrunner/services/result_service.dart';
import 'package:qrunner/services/track_service.dart';
import 'package:qrunner/utils/dialog_utils.dart';

import '../../models/code_scan_data.dart';
import '../cards/read_code_result_card.dart';

class ReadCodesScreen extends StatefulWidget {
  const ReadCodesScreen(
      {Key? key,
      required this.trackId,
      required this.trackType,
      required this.numOfPoints,
      required this.codeList,
      required this.currentUser,
      })
      : super(key: key);

  final String trackId;
  final TrackType trackType;
  final int numOfPoints;
  final List<String> codeList;
  final User? currentUser;

  @override
  State<ReadCodesScreen> createState() => ReadCodesScreenState();
}

class ReadCodesScreenState extends State<ReadCodesScreen> {
  Map<int, CodeScanData> resultBarcodeMap = {};
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    ResultService.readScannedCodes(widget.trackId)
        .then((value) {
          resultBarcodeMap = value;
          setState(() {});
        });

    Connectivity().checkConnectivity().
      then((result) => connectivityResult = result);

    subscription = Connectivity().onConnectivityChanged.listen((result) {
      connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kReadCodesTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: RoundedButton(
              text: kRead,
              color: Colors.green,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const QRCodeReaderScreen();
                })).then((value) => {
                      onCodeScanned(context, value, DateTime.now()),
                      setState(() {}),
                    });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ReadCodeResultCard(
                  index: index,
                  isScanned: isCodeScanned(index),
                );
              },
              shrinkWrap: true,
              itemCount: widget.numOfPoints,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundedButton(
                text: kSubmit,
                onTap: () async {
                  if (resultBarcodeMap.length < widget.numOfPoints) {
                    showConfirmDialog(
                        context, kWarningTitle, kTrackNotCompletedWarning, () {
                      Navigator.pop(context);
                      saveResults();
                    });
                  } else {
                    saveResults();
                  }
                }),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    if (subscription != null) subscription!.cancel();
    super.dispose();
  }

  saveResults() async {
    if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
      showInfoDialog(context, kNoInternetConnection, kOfflineSavingInfo, () {
            Navigator.pop(context);
          });
      return;
    }
    try {
      final resultModel = ResultModel(widget.currentUser!.uid,
          widget.trackId, resultBarcodeMap);

      await ResultService.saveResult(resultModel);
      await TrackService.addUserToCompletedBy(widget.trackId, widget.currentUser!.uid);
      handleResultSavingSuccess();
    } catch (e) {
      showInfoDialog(context, kError, e.toString(), () {
        Navigator.pop(context);
      });
    }
  }

  bool isCodeScanned(int index) {
    return resultBarcodeMap[index] != null;
  }

  bool isReadButtonEnabled(int index) {
    return resultBarcodeMap.length < widget.numOfPoints;
  }

  void onCodeScanned(
      BuildContext context, String code, DateTime scanTimestamp) {
    int indexOfCode = getIndexOfCode(code);
    if (widget.trackType == TrackType.fixedOrderCollecting) {
      validateCodeFixedOrderType(context, code, indexOfCode, scanTimestamp);
    } else {
      validateCodePointCollectingType(context, code, indexOfCode, scanTimestamp);
    }
  }

  int getIndexOfCode(String code) {
    if (widget.trackType == TrackType.fixedOrderCollecting) {
      return resultBarcodeMap.length;
    } else {
      return widget.codeList.indexOf(code);
    }
  }

  void validateCodeFixedOrderType(
      BuildContext context, String value, int index, DateTime scanTimestamp) {
    if (widget.codeList[index] != value) {
      showErrorDialog(context, kErrorScannedCodeIsNotTheNext,
          title: kCodeReadError);
    } else {
      resultBarcodeMap[index] = CodeScanData(value, scanTimestamp);
      ResultService.saveCodeScanToLocalDb(widget.currentUser!.uid,
          widget.trackId,value,index, scanTimestamp);
    }
  }

  void validateCodePointCollectingType(
      BuildContext context, String value, int index, DateTime scanTimestamp) {
    if (!widget.codeList.contains(value)) {
      showErrorDialog(context, kErrorScannedCodeNotPresent,
          title: kCodeReadError);
      return;
    }
    if (resultBarcodeMap[index] != null) {
      showErrorDialog(context, kErrorCodeAlreadyScanned, title: kCodeReadError);
      return;
    }
    resultBarcodeMap[index] = CodeScanData(value, scanTimestamp);
    ResultService.saveCodeScanToLocalDb(widget.currentUser!.uid,
        widget.trackId,value,index, scanTimestamp);
  }

  void handleResultSavingSuccess() {
    showInfoDialog(context, kSaveResultsSuccessTitle, kSaveResultsSuccessTitle,
        () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }
}
