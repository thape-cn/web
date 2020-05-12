CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :aliyun
  end
  config.aliyun_access_key_id  = Rails.application.credentials.dig(:aliyun, :access_key_id)
  config.aliyun_access_key_secret = Rails.application.credentials.dig(:aliyun, :secret_access_key)
  # 你需要在 Aliyun OSS 上面提前创建一个 Bucket
  # You must create a Bucket on Alicloud OSS first.
  config.aliyun_bucket     = "thape-upload"
  # 是否使用内部连接，true - 使用 Aliyun 主机内部局域网的方式访问  false - 外部网络访问
  # When your app server wants deployment in Alicloud internal network, enable this option can speed up uploading
  # by using internal networking. otherwice you must disable it.
  config.aliyun_internal   = true
  # 配置存储的地区数据中心，默认: "cn-hangzhou"
  # Which region of your Bucket.
  config.aliyun_region     = "cn-shanghai"
  # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # 自定义域名请 CNAME 到 you_bucket_name.oss-cn-hangzhou.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  # aliyun_host allow you config a custom host for your Alicloud Bucket, and you also need config that on Alicloud.
  # config.aliyun_host       = "https://foo.bar.com"
  # Bucket 为私有读取请设置 true，默认 false，以便得到的 URL 是能带有 private 空间访问权限的逻辑
  # Tell SDK the privacy of you Bucket, if private CarrierWave xxx.url will generate URL with a expires parameter, default: :public.
  # config.aliyun_mode = :private
  config.aliyun_mode = :public
end
