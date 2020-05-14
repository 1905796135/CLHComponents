#
# Be sure to run `pod lib lint CLHComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CLHComponents'
  s.version          = '1.0.1'
  s.summary          = 'iOS开发 常用组件库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

   s.description      = <<-DESC
                         CirclePageView 轮播图组件
   
                         LineationLabel 创建一个可设置 划线（上，中，下） 的Label
                         
                         LinkTextView        可点击的TextView
                            
                         LMReport            多功能报表控件，支持整体样式和单元格样式的设置，支持复合表头、自适应行高、触
                         摸事件响应已经排序，基本满足常见报表功能 摘自 https://github.com/littleMeaning/LMReport
                        
                         ScrollOptionsMenu   横向排版的菜单选择栏
                         SearchView          搜索框 可自定义搜索框样式
                        
                         ShadeRoundLoop  DataRoundLoopView 饼状图  ShadeRoundLoopView 渐变色圆环
                        
                         ShadowView 创建一个可设置同时设置圆角和阴影的View
                         
                         
                         WaterMarkView       创建一个带水印的 UIImageView
                        DESC

  s.homepage         = 'https://github.com/1905796135/CLHComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'clh2046@163.com' => 'clh2046@163.com' }
  s.source           = { :git => 'https://github.com/1905796135/CLHComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#  s.source_files = 'CLHComponents/Classes/**/*.{h,m}'
  s.source_files = 'CLHComponents/Classes/CLHComponents.h'
  s.public_header_files = 'CLHComponents/Classes/CLHComponents.h'
  
    
  s.subspec 'LineationLabel' do |lineationLabel|
      lineationLabel.source_files = 'CLHComponents/Classes/LineationLabel/**/*'
      lineationLabel.public_header_files = 'CLHComponents/Classes/LineationLabel/**/*.h'
  end
  
  s.subspec 'CirclePageView' do |circlePageView|
      circlePageView.public_header_files = 'CLHComponents/Classes/CirclePageView/**/*.h'
      circlePageView.source_files = 'CLHComponents/Classes/CirclePageView/**/*'
      circlePageView.dependency 'CoreCode'
      circlePageView.dependency 'Masonry'
      circlePageView.dependency 'FLAnimatedImage'
      circlePageView.dependency 'SDWebImage'#,'~> 4.2.1'
      circlePageView.dependency 'SDWebImage/GIF'
      circlePageView.dependency 'SDWebImage/WebP'
  end
  
  s.subspec 'LinkTextView' do |linkTextView|
      linkTextView.source_files = 'CLHComponents/Classes/LinkTextView/**/*'
      linkTextView.public_header_files = 'CLHComponents/Classes/LinkTextView/**/*.h'
  end
  
  s.subspec 'LMReport' do |lMReport|
      lMReport.source_files = 'CLHComponents/Classes/LMReport/**/*'
      lMReport.public_header_files = 'CLHComponents/Classes/LMReport/**/*.h'
      lMReport.dependency 'Masonry'
  end
  
  s.subspec 'NavigationTitleView' do |lMReport|
      lMReport.source_files = 'CLHComponents/Classes/NavigationTitleView/**/*'
      lMReport.public_header_files = 'CLHComponents/Classes/NavigationTitleView/**/*.h'
  end
  
  s.subspec 'ScrollOptionsMenu' do |scrollOptionsMenu|
      scrollOptionsMenu.source_files = 'CLHComponents/Classes/ScrollOptionsMenu/**/*'
      scrollOptionsMenu.public_header_files = 'CLHComponents/Classes/ScrollOptionsMenu/**/*.h'
  end
  
  s.subspec 'SearchView' do |searchView|
      searchView.source_files = 'CLHComponents/Classes/SearchView/**/*'
      searchView.public_header_files = 'CLHComponents/Classes/SearchView/**/*.h'
      searchView.resource_bundles = {
        'SearchViewResources' => ['CLHComponents/Assets/SearchView/*.png']
      }
  end
  
  s.subspec 'ShadeRoundLoop' do |shadeRoundLoop|
      shadeRoundLoop.source_files = 'CLHComponents/Classes/ShadeRoundLoop/**/*'
      shadeRoundLoop.public_header_files = 'CLHComponents/Classes/ShadeRoundLoop/**/*.h'
  end
  
  s.subspec 'ShadowView' do |shadowView|
      shadowView.source_files = 'CLHComponents/Classes/ShadowView/**/*'
      shadowView.public_header_files = 'CLHComponents/Classes/ShadowView/**/*.h'
  end
  
  s.subspec 'WaterMarkView' do |waterMarkView|
      waterMarkView.source_files = 'CLHComponents/Classes/WaterMarkView/**/*'
      waterMarkView.public_header_files = 'CLHComponents/Classes/WaterMarkView/**/*.h'
  end
  
end
