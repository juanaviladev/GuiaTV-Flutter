class License {
    String source;
    String url;

    License({this.source, this.url});

    factory License.fromJson(Map<String, dynamic> json) {
        return License(
            source: json['source'], 
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['source'] = this.source;
        data['url'] = this.url;
        return data;
    }
}