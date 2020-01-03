class StreamingOption {
    String format;
    String url;

    StreamingOption({this.format, this.url});

    factory StreamingOption.fromJson(Map<String, dynamic> json) {
        return StreamingOption(
            format: json['format'],
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['format'] = this.format;
        data['url'] = this.url;
        return data;
    }
}