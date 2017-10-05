NGINX_SRC_RPM := nginx-1.13.5-1.el7.ngx.src.rpm
NGX_MRUBY_VER := 1.20.1
SITEGUARD_URL := ＜さくらインターネットより提供されているSiteGuard LiteのダウンロードURLを記載します。＞
SITEGUARD_VER := 3.20-0

IMAGE_NAME := siteguard-ngx_mruby-package
TARGZ_FILE := nginx.tar.gz

.PHONY: build clean

build:
	[ -d $@.bak ] && rm -rf $@.bak || :
	[ -d $@ ] && mv $@ $@.bak || :
	docker build -f Dockerfile -t ${IMAGE_NAME} --build-arg nginx_src_rpm=${NGINX_SRC_RPM} --build-arg ngx_mruby_ver=${NGX_MRUBY_VER} --build-arg siteguard_url=${SITEGUARD_URL} --build-arg siteguard_ver=${SITEGUARD_VER} .
	docker run --name $(IMAGE_NAME)-tmp $(IMAGE_NAME)
	mkdir -p tmp
	docker wait $(IMAGE_NAME)-tmp
	docker cp $(IMAGE_NAME)-tmp:/tmp/$(TARGZ_FILE) tmp
	docker rm $(IMAGE_NAME)-tmp
	mkdir $@
	tar -xzf tmp/$(TARGZ_FILE) -C $@
	rm -rf tmp
	docker images | grep -q $(IMAGE_NAME) && docker rmi $(IMAGE_NAME) || true

clean:
	rm -rf build
	docker images | grep -q ${IMAGE_NAME} && docker rmi ${IMAGE_NAME} || true
