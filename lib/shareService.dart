import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class ShareService {
  final String link = "http://my1party.com/events/";
  final String past_images = "http://my1party.com/past-events/";
  final String ticket = "https://my1party.com/ticket";
  Future<Uint8List> _getBites(String url) async {
    var response = await get(
      Uri.parse(url),
    );
    return response.bodyBytes;
  }

  void shareImage(Uint8List data, String title) async {
    // var bites = await _getBites(path);
    var link = past_images;
    WcFlutterShare.share(
        text: title,
        subject: "Image",
        sharePopupTitle: "code.png",
        mimeType: "image/png",
        fileName: "code" ".png",
        bytesOfFile: data);
  }
}

ShareService shareService = ShareService();
ShareService get shareS => shareService;
