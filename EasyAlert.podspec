
Pod::Spec.new do |s|

  s.name	= 'EasyAlert' 
  s.version	= '1.0.0' 
  s.summary	= 'Show Alert with your customized view.' 
  s.homepage	= 'https://github.com/ousikou/EasyAlert' 
  s.license	= { type: 'MIT', file: 'LICENSE' } 
  s.author	= { 'Ousikou' => 'wangziheng@fenrir-tec.com' } 
  s.platform	= :ios, '9.0' 
  s.source	= { :git => 'https://github.com/ousikou/EasyAlert.git', :tag => s.version } 
  s.source_files = 'EasyAlert/**' 
  s.frameworks = 'UIKit' 
  s.requires_arc = true

end 
