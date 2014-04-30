Pod::Spec.new do |s|
  s.name         = "ASEndpoint"
  s.version      = "1.0.0"
  s.summary      = "A nice generic framework for Protobuf endpoints"
  s.homepage     = "https://github.com/asarazan/ASEndpoint"
  s.license      = 'Apache'
  s.authors      = { "Aaron Sarazan" => "aaron@sarazan.net" }
  s.source       = { :git => "https://github.com/sarazan/ASEndpoint.git" }
  s.platform     = :ios, '7.0'
  s.source_files = "*.{h|m}"
end
