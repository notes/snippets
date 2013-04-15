#!/bin/sh

# regular GET
curl http://example.jp/

# regular HEAD
curl --head http://example.jp/

# output detail
curl --verbose http://example.jp/

# output trace
curl --trace-ascii - http://example.jp/

# change User-Agent header
curl --user-agent Mozilla http://example.jp/

# POST application/x-www-urlencoded
curl --data name=value http://example.jp/

# POST multipart/form-data
curl --form name=value --form file=@/etc/services http://example.jp/uploader


