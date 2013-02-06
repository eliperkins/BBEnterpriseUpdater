Pod::Spec.new do |s|
  s.name     = 'BBEnterpriseUpdater'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Updater for Apple Enterprise app deployments.'
  s.homepage = 'https://github.com/eliperkins/BBEnterpriseUpdater'
  s.authors  = { 'Eli Perkins' => 'eli@onemightyroar.com' }
  s.source   = { :git => 'https://github.com/eliperkins/BBEnterpriseUpdater.git', :tag => '0.0.1' }
  s.source_files = 'BBEnterpriseUpdater'
  s.requires_arc = true
  s.dependency 'AFNetworking', '>= 0.9'
end