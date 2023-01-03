import 'dart:io';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/urlConstants.dart';
import 'package:weather_app_2/models/homescreen/articlemodel.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NetworkController extends GetxController with StateMixin<List<Article>> {
  @override
  void onInit() {
    // TODO: implement onInit
    change([], status: RxStatus.empty());

    super.onInit();
  }

  Future<void> makeList(location) async {
    if (state?.length == 0) {
      try {
        change([], status: RxStatus.loading());
        final response = await http.Client().get(Uri.parse(queryUrl + location),
            headers: {"Access-Control_Allow_Origin": "*"});
        var document;

        if (response.statusCode == 200) {
          List<Article> aList = [];

          document = parse(response.body);
          var elements = document.querySelectorAll('ol');
          var loa = elements.last;
          var initList = loa.querySelectorAll('.css-1l4w6pd');

          for (var i = 0; i < initList.length; i++) {
            //AUTHOR
            var rawA = initList[i].querySelector('.css-15w69y9');

            //if the value of the left is null, then use a default value of ''

            // rawLink
            var rawLink = initList[i].querySelector('.css-2fgx4k').parent;

            //TITLE
            var rawT = initList[i].querySelector('.css-2fgx4k');

            //DESC
            var rawD = initList[i].querySelector('.css-16nhkrn');

            //IMG
            var rawImg = initList[i].querySelector('.css-rq4mmj');

            var newA = rawA != null ? rawA.innerHtml : '';
            var newT = rawT != null ? rawT.innerHtml : '';
            var newD = rawD != null ? rawD.innerHtml : '';
            var newImg = rawImg != null
                ? rawImg.attributes['src']
                : 'https://via.placeholder.com/150';
            var newLink = rawLink != null
                ? rawLink.attributes['href']
                : 'https://www.nytimes.com/';
            aList.add(Article(
                author: newA,
                desc: newD,
                img: newImg,
                title: newT,
                link: Uri.parse(baseUrl + newLink)));
          }

          change(aList, status: RxStatus.success());
        } else {
          throw HttpException('error 404');
        }
      } catch (e) {
        change([], status: RxStatus.error(e.toString()));
      }
    } else {
      return print('error did not work');
    }
  }

  // name of function
  Future<void> openUrl(url) async {
    print(await canLaunchUrl(url));
    // package function
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
