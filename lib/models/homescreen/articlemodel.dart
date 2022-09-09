class Article {
  String? title;
  String? desc;
  String? author;
  String? img;
  Uri? link;

  Article(
      {String? title, String? desc, String? author, String? img, Uri? link}) {
    this.title = title;
    this.desc = desc;
    this.author = author;
    this.img = img;
    this.link = link;
  }
  @override
  String toString() {
    // TODO: implement toString
    return "Article: ${title} ${author}.";
  }
}
